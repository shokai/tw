
module Tw
  class Client::Stream
    def initialize(user=nil)
      user = Tw::Auth.get_or_regist_user user
      @client = Twitter::Streaming::Client.new do |config|
        config.consumer_key = Conf['consumer_key']
        config.consumer_secret = Conf['consumer_secret']
        config.access_token = user['access_token']
        config.access_token_secret = user['access_secret']
      end
    end

    def user_stream(&block)
      raise ArgumentError, 'block not given' unless block_given?
      @client.user do |chunk|
        if tweet = get_if_tweet(chunk)
          yield tweet
        end
      end
    end

    def filter(*track_words, &block)
      raise ArgumentError, 'block not given' unless block_given?
      @client.filter :track => track_words.join(',') do |chunk|
        if tweet = get_if_tweet(chunk)
          yield tweet
        end
      end
    end

    private
    def get_if_tweet(chunk)
      return nil unless chunk.kind_of? Twitter::Tweet
      Tw::Tweet.new(:id => chunk.id,
                    :user => chunk.user.screen_name,
                    :text => chunk.text,
                    :time => chunk.created_at)
    end

  end
end
