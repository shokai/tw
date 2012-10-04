
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
        next unless m.user and m.user.screen_name and m.text and m.created_at and m.id
        data = {
          :id => m.id,
          :user => m.user.screen_name,
          :text => m.text,
          :time => (Time.parse m.created_at)
        }
        yield data
      end
    end


    def filter(*words, &block)
    end

  end
end
