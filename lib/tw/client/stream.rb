
module Tw
  class Client::Stream
    def initialize(user=nil)
      user = Conf['default_user'] unless user
      if user == nil and Conf['users'].empty?
        Tw::Client.add_user
        return
      end
      raise ArgumentError, "Argument must be instance of String or Hash." unless [Hash, String].include? user.class
      if user.class == String
        raise ArgumentError, "user \"#{user}\" not exists." unless Conf['users'].include? user
        user = Conf['users'][user]
      end
      UserStream.configure do |config|
        config.consumer_key = Conf['consumer_key']
        config.consumer_secret = Conf['consumer_secret']
        config.oauth_token = user['access_token']
        config.oauth_token_secret = user['access_secret']
      end

      puts '-- waiting stream..'
      @client = UserStream::Client.new
    end

    def user_stream(&block)
      raise ArgumentError, 'block not given' unless block_given?
      @client.user do |m|
        if data = tweet?(m)
          yield data
        end
      end
    end

    def filter(*track_words, &block)
      raise ArgumentError, 'block not given' unless block_given?
      track_words = track_words.join(',')
      puts "track #{track_words}"
      @client.filter :track => track_words do |m|
        if data = tweet?(m)
          yield data
        end
      end
    end

    private
    def tweet?(chunk)
      return false unless chunk.user and chunk.user.screen_name and chunk.text and chunk.created_at and chunk.id
      {
        :id => chunk.id,
        :user => chunk.user.screen_name,
        :text => chunk.text,
        :time => (Time.parse chunk.created_at)
      }
    end

  end
end
