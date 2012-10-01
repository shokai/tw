
module Tw::App
  class Main
    private
    def cmds
      {
        'user:add'.to_sym => lambda{|v|
          client.add_user
        },
        'user:list'.to_sym => lambda{|v| 
          Tw::Conf['users'].keys.each do |name|
            puts name == Tw::Conf['default_user'] ? "* #{name}" : "  #{name}"
          end
          puts "(#{Tw::Conf['users'].size} users)"
        },
        'user:default'.to_sym => lambda{|v|
          if v.class == String
            Tw::Conf['default_user'] = v
            Tw::Conf.save
            puts "set default user \"@#{Tw::Conf['user:default']}\""
          else
            puts "@"+Tw::Conf['default_user']            
          end
        },
        :pipe => lambda{|v|
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
