
module Tw::App
  class Main

    private
    def regist_cmds
      cmd :user do |v, opts|
        if v == true
          STDERR.puts 'e.g.  tw "hello" --user=USERNAME'
          on_error
        end
      end

      cmd 'user:add' do |v, opts|
        Tw::Auth.regist_user
        on_exit
      end

      cmd 'user:list' do |v, opts|
        Tw::Conf['users'].keys.each do |name|
          puts name == Tw::Conf['default_user'] ? "* #{name}" : "  #{name}"
        end
        puts "(#{Tw::Conf['users'].size} users)"
        on_exit
      end

      cmd 'user:default' do |v, opts|
        if v.class == String
          Tw::Conf['default_user'] = v
          Tw::Conf.save
          puts "set default user \"@#{Tw::Conf['default_user']}\""
        else
          puts "@"+Tw::Conf['default_user'] if Tw::Conf['default_user']
          STDERR.puts "e.g.  tw --user:default=USERNAME"
        end
        on_exit
      end

      cmd :timeline do |v, opts|
        unless v.class == String
          auth
          Render.display client.home_timeline, opts[:format]
          on_exit
        end
      end

      cmd :dm do |v, opts|
        auth
        Render.display client.direct_messages, opts[:format]
        on_exit
      end

      cmd 'dm:to' do |to, opts|
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

      cmd :search do |v, opts|
        if v.class == String
          auth
          Render.display client.search(v), opts[:format]
          on_exit
        else
          STDERR.puts "e.g.  tw --search=ruby"
          on_error
        end
      end

      cmd :stream do |v, opts|
        stream = Tw::Client::Stream.new @parser.has_param?(:user) ? @parser[:user] : nil
        Render.puts "-- waiting stream.."
        loop do
          begin
            stream.user_stream do |s|
              Render.display s, opts[:format]
            end
          rescue Timeout::Error, SocketError => e
            sleep 5
            next
          rescue => e
            STDERR.puts e
            on_error
          end
        end
        on_exit
      end

      cmd 'stream:filter' do |v, opts|
        unless v.class == String
          STDERR.puts "e.g.  tw --stream:filter=ruby,java"
          on_error
        else
          track_words = v.split(/\s*,\s*/)
          stream = Tw::Client::Stream.new @parser.has_param?(:user) ? @parser[:user] : nil
          Render.puts "-- waiting stream..  track \"#{track_words.join(',')}\""
          loop do
            begin
              stream.filter track_words do |s|
                Render.display s, opts[:format]
              end
            rescue Timeout::Error, SocketError => e
              sleep 5
              next
            rescue => e
              STDERR.puts e
              on_error
            end
          end
          on_exit
        end
      end

      cmd :pipe do |v, opts|
        auth
        while line = STDIN.gets do
          line.split(/(.{140})/u).select{|m|m.size>0}.each do |message|
            begin
              client.tweet message
            rescue => e
              STDERR.puts e.message
            end
          end
          sleep 1
        end
        on_exit
      end

      cmd :version do |v, opts|
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
