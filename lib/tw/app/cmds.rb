module Tw::App
  class Main

    private
    def regist_cmds
      cmd :user do |v, opts|
        if v == true
          STDERR.puts 'e.g.  tw "hello" --user=USERNAME'
          on_error
        else
          Render.puts "switch user -> @#{v}"
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
        unless opts[:pipe]
          message = opts.argv.join(' ')
          len = message.char_length_with_t_co
          if len > 140
            STDERR.puts "message too long (#{len} chars)"
            on_error
          elsif len < 1
            STDERR.puts 'e.g.  tw --dm:to=USERNAME  "hello"'
            on_error
          else
            puts "DM to @#{to}"
            puts "\"#{message}\"?  (#{len} chars)"
            unless opts.has_option? :yes
              puts '[Y/n]'
              on_exit if STDIN.gets.strip =~ /^n/i
            end
            auth
            client.direct_message_create to, message
          end
          on_exit
        end
      end

      cmd :favorite do |v, opts|
        if opts.has_param? :favorite
          id = opts[:favorite]
          auth
          client.show_status id
          puts 'Fav this?'
          unless opts.has_option? :yes
            puts '[Y/n]'
            on_exit if STDIN.gets.strip =~ /^n/i
          end
          puts "success!" if client.favorite id
        end
        on_exit
      end

      cmd :retweet do |v, opts|
        if opts.has_param? :retweet
          id = opts[:retweet]
          auth
          client.show_status id
          puts 'RT this?'
          unless opts.has_option? :yes
            puts '[Y/n]'
            on_exit if STDIN.gets.strip =~ /^n/i
          end
          puts "success!" if client.retweet id
        end
        on_exit
      end

      cmd :delete do |v, opts|
        if opts.has_param? :delete
          id = opts[:delete]
          auth
          client.show_status id
          puts 'Delete this?'
          unless opts.has_option? :yes
            puts '[Y/n]'
            on_exit if STDIN.gets.strip =~ /^n/i
          end
          puts "success!" if client.destroy_status id
        end
        on_exit
      end

      cmd :pipe do |v, opts|
        auth
        lines = STDIN.readlines.join
        lines.split(/(.{140})/u).select{|m|m.size>0}.each do |message|
          begin
            if opts.has_param? 'dm:to'
              puts to = opts['dm:to']
              client.direct_message_create to, message
            else
              tweet_opts = {}
              tweet_opts[:in_reply_to_status_id] = opts[:status_id] if opts.has_param? :status_id
              client.tweet message, tweet_opts
            end
          rescue => e
            STDERR.puts e.message
          end
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
        stream = Tw::Client::Stream.new opts.has_param?(:user) ? opts[:user] : nil
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
          stream = Tw::Client::Stream.new opts.has_param?(:user) ? opts[:user] : nil
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
