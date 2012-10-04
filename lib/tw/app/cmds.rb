
module Tw::App
  class Main

    private
    def regist_cmds
      cmd :user do |v|
        if v == true
          STDERR.puts 'e.g.  tw "hello" --user=USERNAME'
          on_error
        end
      end

      cmd 'user:add' do |v|
        Tw::Auth.regist_user
        on_exit
      end

      cmd 'user:list' do |v|
        Tw::Conf['users'].keys.each do |name|
          puts name == Tw::Conf['default_user'] ? "* #{name}" : "  #{name}"
        end
        puts "(#{Tw::Conf['users'].size} users)"
        on_exit
      end

      cmd 'user:default' do |v|
        if v.class == String
          Tw::Conf['default_user'] = v
          Tw::Conf.save
          puts "set default user \"@#{Tw::Conf['default_user']}\""
        else
          puts "@"+Tw::Conf['default_user'] if Tw::Conf['default_user']
          puts "e.g.  tw --user:default=USERNAME"
        end
        on_exit
      end

      cmd :timeline do |v|
        unless v.class == String
          auth
          Render.display client.home_timeline
          on_exit
        end
      end

      cmd :dm do |v|
        auth
        Render.display client.direct_messages
        on_exit
      end

      cmd 'dm:to' do |to|
        message = @parser.argv.join(' ')
        len = message.split(//u).size
        if len > 140
          STDERR.puts "message too long (#{len} chars)"
          on_error
        elsif len < 1
          STDERR.puts 'e.g.  tw --dm:to=USERNAME  "hello"'
          on_error
        else
          puts "dm \"#{message}\"?  (#{len} chars)"
          puts '[Y/n]'
          on_exit if STDIN.gets.strip =~ /^n/i
          auth
          client.direct_message_create to, message
        end
        on_exit
      end

      cmd :search do |v|
        if v.class == String
          auth
          Render.display client.search v
          on_exit
        else
          STDERR.puts "e.g.  tw --search=ruby"
          on_error
        end
      end

      cmd :stream do |v|
        stream = Tw::Client::Stream.new @parser.has_param?(:user) ? @parser[:user] : nil
        loop do
          puts "-- waiting stream.."
          begin
            stream.user_stream do |s|
              Render.display s
            end
          rescue Timeout::Error, SocketError => e
            STDERR.puts '-- stream closed'
            sleep 3
            next
          rescue => e
            STDERR.puts e
            on_error
          end
        end
        on_exit
      end

      cmd 'stream:filter' do |v|
        unless v.class == String
          STDERR.puts "e.g.  tw --stream:filter=ruby,java"
          on_error
        else
          track_words = v.split(/\s*,\s*/)
          stream = Tw::Client::Stream.new @parser.has_param?(:user) ? @parser[:user] : nil
          loop do
            puts "-- waiting stream..  track \"#{track_words.join(',')}\""
            begin
              stream.filter track_words do |s|
                Render.display s
              end
            rescue Timeout::Error, SocketError => e
              STDERR.puts '-- stream closed'
              sleep 3
              next
            rescue => e
              STDERR.puts e
              on_error
            end
          end
          on_exit
        end
      end

      cmd :pipe do |v|
        auth
        STDIN.read.split(/[\r\n]+/).each do |line|
          line.split(/(.{140})/u).select{|m|m.size>0}.each do |message|
            client.tweet message
          end
          sleep 1
        end
        on_exit
      end

      cmd :version do |v|
        puts "tw version #{Tw::VERSION}"
        on_exit
      end
    end

    def cmd(name, &block)
      if block_given?
        cmds[name.to_sym] = block
      else
        return cmds[name.to_sym]
      end
    end

    def cmds
      @cmds ||= Hash.new
    end

  end
end
