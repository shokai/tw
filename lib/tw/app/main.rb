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
      @args = ArgsParser.parse argv, :style => :equal do
        arg :user, 'user account', :alias => :u
        arg 'user:add', 'add user'
        arg 'user:list', 'show user list'
        arg 'user:default', 'set default user'
        arg :timeline, 'show timeline', :alias => :tl
        arg :dm, 'show direct messages'
        arg 'dm:to', 'create direct message'
        arg :favorite, 'favorite tweet', :alias => :fav
        arg :retweet, 'retweet', :alias => :rt
        arg :delete, 'delete tweet', :alias => :del
        arg :search, 'search public timeline', :alias => :s
        arg :stream, 'show user stream', :alias => :st
        arg :status_id, 'show status_id', :alias => :id
        arg :file, 'upload file'
        arg :pipe, 'pipe tweet'
        arg :format, 'output format', :default => 'text'
        arg :silent, 'silent mode'
        arg :yes, 'do not show dialogue'
        arg :conf, 'config file', :default => Tw::Conf.conf_file
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

        validate :file, "file does not exists" do |v|
          File.exists? v
        end
      end

      if @args.has_option? :help
        STDERR.puts "Tw - Twitter client on Ruby v#{Tw::VERSION}"
        STDERR.puts "     http://shokai.github.io/tw"
        STDERR.puts
        STDERR.puts @args.help
        STDERR.puts
        STDERR.puts "e.g."
        STDERR.puts "tweet  tw hello world"
        STDERR.puts "       echo 'hello' | tw --pipe"
        STDERR.puts "       tw 'yummy!!' --file=food.jpg --yes"
        STDERR.puts "read   tw @username"
        STDERR.puts "       tw @username @user2 @user2/listname"
        STDERR.puts "       tw --search=ruby"
        STDERR.puts "       tw --stream"
        STDERR.puts "       tw --stream:filter=ruby,java"
        STDERR.puts "       tw --dm:to=username \"hello!\""
        STDERR.puts "id     tw @shokai --id"
        STDERR.puts "       tw --id=334749349588377601"
        STDERR.puts 'reply  tw "@shokai wow!!" --id=334749349588377601'
        STDERR.puts "       tw --fav=334749349588377601"
        STDERR.puts "       tw --rt=334749349588377601"
        STDERR.puts "       tw --format=json"
        STDERR.puts '       tw --format="@#{user} #{text} - https://twitter.com/#{user}/#{id}"'
        STDERR.puts "delete tw --del=334749349588377601"
        on_exit
      end

      Render.silent = (@args.has_option? :silent or @args.has_param? :format)
      Render.show_status_id = @args[:status_id]
      Tw::Conf.conf_file = @args[:conf]

      regist_cmds

      cmds.each do |name, cmd|
        next unless @args[name]
        cmd.call @args[name], @args
      end

      auth
      if @args.argv.size < 1
        if @args.has_param? :status_id
          client.show_status @args[:status_id]
        else
          Render.display client.mentions, @args[:format]
        end
      elsif all_requests?(@args.argv)
        Render.display Parallel.map(@args.argv, :in_threads => @args.argv.size){|arg|
          if user = username?(arg)
            res = client.user_timeline user
          elsif (user, list = listname?(arg)) != false
            res = client.list_timeline(user, list)
          end
          res
        }, @args[:format]
      else
        message = @args.argv.join(' ')
        tweet_opts = {}
        if (len = message.char_length_with_t_co) > 280
          STDERR.puts "tweet too long (#{len} chars)"
          on_error
        else
          if @args.has_param? :status_id
            client.show_status @args[:status_id]
            puts "--"
            puts "reply \"#{message}\"? (#{len} chars)"
            tweet_opts[:in_reply_to_status_id] = @args[:status_id]
          else
            puts "tweet \"#{message}\"?  (#{len} chars)"
            if @args.has_param? :file
              puts "upload \"#{@args[:file]}\"? (#{File.size @args[:file]} bytes)"
            end
          end
          unless @args.has_option? :yes
            puts '[Y/n]'
            on_exit if STDIN.gets.strip =~ /^n/i
          end
        end
        begin
          if @args.has_param? :file
            client.tweet_with_file message, File.open(@args[:file]), tweet_opts
          else
            client.tweet message, tweet_opts
          end
        rescue => e
          STDERR.puts e.message
        end
      end
    end

    private
    def auth
      return unless @args
      client.auth @args.has_param?(:user) ? @args[:user] : nil
    end

  end
end
