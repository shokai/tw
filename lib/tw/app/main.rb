
require File.expand_path 'opt_parser', File.dirname(__FILE__)
require File.expand_path 'cmds', File.dirname(__FILE__)
require File.expand_path 'render', File.dirname(__FILE__)

module Tw::App
  
  def self.new
    Main.new
  end

  class Main

    def client
      @client ||= Tw::Client.new
    end

    def run(argv)
      @parser = ArgsParser.parse argv, :style => :equal do
        arg :user, 'user account'
        arg :timeline, 'show timeline'
        arg :search, 'search public timeline'
        arg :help, 'show help', :alias => :h
      end

      cmds.each do |name, cmd|
        next unless @parser[name]
        cmd.call Tw::Opts[name]
        return
      end
      
      client.auth @parser.has_param?(:user) ? @parser[:user] : nil
      if @parser.argv.size < 1
        Render.display client.mentions
      elsif all_requests?(@parser.argv)
        Render.display @parser.argv.map{|arg|
          if word = search_word?(arg)
            res = client.search word
          elsif user = username?(arg)
            res = client.user_timeline user
          elsif (user, list =listname?(arg)) != false
            res = client.list_timeline(user, list)
          end
          res
        }
      else
        message = @parser.argv.join(' ')
        if (len = message.split(//u).size) > 140
          puts "tweet too long (#{len} chars)"
          return 1
        else
          puts "tweet \"#{message}\"?  (#{len} chars)"
          puts '[Y/n]'
          return 0 if STDIN.gets.strip =~ /^n/i
        end
        client.tweet message
      end
    end

  end
end
