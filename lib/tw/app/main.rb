
require File.expand_path 'opt_parser', File.dirname(__FILE__)
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
      Tw::App::OptParser.parse argv
      cmds.each do |name, cmd|
        next unless Tw::Opts.keys.include? name
        cmd.call Tw::Opts[name]
        return
      end
      
      client.auth Tw::Opts['user'].class == String ? Tw::Opts['user'] : nil
      if Tw::App::OptParser.argv.size < 1
        Tw::App::Render.display client.mentions
      elsif Tw::App::OptParser.all_requests?
        Tw::App::Render.display Tw::App::OptParser.argv.map{|arg|
          if word = Tw::App::OptParser.search_word?(arg)
            res = client.search word
          elsif user = Tw::App::OptParser.username?(arg)
            res = client.user_timeline user
          elsif (user, list = Tw::App::OptParser.listname?(arg)) != false
            res = client.list_timeline(user, list)
          end
          res
        }
      else
        message = Tw::App::OptParser.argv.join(' ')
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

    private
    def cmds
      {
        'user:add' => lambda{|v|
          client.add_user
        },
        'user:list' => lambda{|v| 
          Tw::Conf['users'].keys.each do |name|
            puts name == Tw::Conf['default_user'] ? "* #{name}" : "  #{name}"
          end
          puts "(#{Tw::Conf['users'].size} users)"
        },
        'user:default' => lambda{|v|
          if v.class == String
            Tw::Conf['default_user'] = v
            Tw::Conf.save
            puts "set default user \"@#{Tw::Opts['user:default']}\""
          else
            puts "@"+Tw::Conf['default_user']            
          end
        },
        'help' => lambda{|v|
          puts Tw.help
        },
        'pipe' => lambda{|v|
          STDIN.read.split(/[\r\n]+/).each do |line|
            line.split(/(.{140})/u).select{|m|m.size>0}.each do |message|
              client.tweet message
            end
            sleep 1
          end
        }
      }
    end

  end
end
