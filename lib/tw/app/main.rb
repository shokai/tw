require File.expand_path 'opt_parser', File.dirname(__FILE__)
require File.expand_path 'cmds', File.dirname(__FILE__)
require File.expand_path 'render', File.dirname(__FILE__)
require File.expand_path 'helper', File.dirname(__FILE__)

module Tw::App
  
  def self.new
    Main.new
  end

  class Main
    def initialize
      on_exit do
        exit 0
      end

      on_error do
        exit 1
      end
    end

    def client
      @client ||= Tw::Client.new
    end

    def on_exit(&block)
      if block_given?
        @on_exit = block
      else
        @on_exit.call if @on_exit
      end
    end

    def on_error(&block)
      if block_given?
        @on_error = block
      else
        @on_error.call if @on_error
      end
    end

    def run(argv)
      @parser = ArgsParser.parse argv, :style => :equal do
        arg :user, 'user account', :alias => :u
        arg 'user:add', 'add user'
        arg 'user:list', 'show user list'
        arg 'user:default', 'set default user'
        arg :timeline, 'show timeline', :alias => :tl
        arg :dm, 'show direct messages'
        arg 'dm:to', 'create direct message'
        arg :search, 'search public timeline', :alias => :s
        arg :stream, 'show user stream', :alias => :st
        arg :pipe, 'pipe tweet'
        arg :version, 'show version', :alias => :v
        arg :help, 'show help', :alias => :h

        validate :user, 'invalid user name' do |v|
          v =~ /^[a-zA-Z0-9_]+$/
        end

        validate 'user:default', 'invalid user name' do |v|
          v =~ /^[a-zA-Z0-9_]+$/
        end

        validate 'dm:to', 'invalid user name' do |v|
          v =~ /^[a-zA-Z0-9_]+$/
        end
      end

      if @parser.has_option? :help
        STDERR.puts "Tw - Twitter client on Ruby v#{Tw::VERSION}"
        STDERR.puts "     http://shokai.github.com/tw"
        STDERR.puts
        STDERR.puts @parser.help
        STDERR.puts
        STDERR.puts "e.g."
        STDERR.puts "tweet  tw hello world"
        STDERR.puts "       echo 'hello' | tw --pipe"
        STDERR.puts "read   tw @username"
        STDERR.puts "       tw @username @user2 @user2/listname"
        STDERR.puts "       tw --search=ruby"
        STDERR.puts "       tw --stream"
        STDERR.puts "       tw --stream:filter=ruby,java"
        STDERR.puts "       tw --dm:to=username \"hello!\""
        on_exit
      end

      regist_cmds

      cmds.each do |name, cmd|
        next unless @parser[name]
        cmd.call @parser[name]
      end

      auth
      if @parser.argv.size < 1
        Render.display client.mentions
      elsif all_requests?(@parser.argv)
        Render.display Parallel.map(@parser.argv, :in_threads => @parser.argv.size){|arg|
          if user = username?(arg)
            res = client.user_timeline user
          elsif (user, list =listname?(arg)) != false
            res = client.list_timeline(user, list)
          end
          res
        }
      else
        message = @parser.argv.join(' ')
        if (len = message.split(//u).size) > 140
          STDERR.puts "tweet too long (#{len} chars)"
          on_error
        else
          puts "tweet \"#{message}\"?  (#{len} chars)"
          puts '[Y/n]'
          on_exit if STDIN.gets.strip =~ /^n/i
        end
        client.tweet message
      end
    end

    private
    def auth
      return unless @parser
      client.auth @parser.has_param?(:user) ? @parser[:user] : nil
    end

  end
end
