module Tw
  class Client

    def mentions
      @rest_client.mentions.map{|m|
        Tw::Tweet.new(:id => m.id,
                      :user => m.user.screen_name,
                      :text => m.text,
                      :time => m.created_at,
                      :fav_count => m.favorite_count,
                      :rt_count => m.retweet_count)
      }
    end

    def search(word)
      @rest_client.search(word).take(20).map{|m|
        Tw::Tweet.new(:id => m.id,
                      :user => m.user.screen_name,
                      :text => m.text,
                      :time => m.created_at,
                      :fav_count => m.favorite_count,
                      :rt_count => m.retweet_count)
      }
    end

    def home_timeline
      @rest_client.home_timeline.map{|m|
        Tw::Tweet.new(:id => m.id,
                      :user => m.user.screen_name,
                      :text => m.text,
                      :time => m.created_at,
                      :fav_count => m.favorite_count,
                      :rt_count => m.retweet_count)
      }
    end

    def user_timeline(user)
      @rest_client.user_timeline(user).map{|m|
        Tw::Tweet.new(:id => m.id,
                      :user => m.user.screen_name,
                      :text => m.text,
                      :time => m.created_at,
                      :fav_count => m.favorite_count,
                      :rt_count => m.retweet_count)
      }
    end

    def list_timeline(user,list)
      @rest_client.list_timeline(user, list).map{|m|
        Tw::Tweet.new(:id => m.id,
                      :user => m.user.screen_name,
                      :text => m.text,
                      :time => m.created_at,
                      :fav_count => m.favorite_count,
                      :rt_count => m.retweet_count)
      }
    end

    def direct_messages
      [@rest_client.direct_messages.map{|m|
         Tw::Tweet.new(:id => m.id,
                       :user => m.sender.screen_name,
                       :text => m.text,
                       :time => m.created_at)
       }, @rest_client.direct_messages_sent.map{|m|
         Tw::Tweet.new(:id => m.id,
                       :user => {
                         :from => m.sender.screen_name,
                         :to => m.recipient.screen_name
                       },
                       :text => m.text,
                       :time => m.created_at)
       }].flatten
    end

    def tweet(message, opts={})
      res = @rest_client.update message, opts
      puts res.text
      puts "https://twitter.com/#{res.user.screen_name}/status/#{res.id}"
      puts res.created_at
    end

    def tweet_with_file(message, file, opts={})
      res = @rest_client.update_with_media message, file, opts
      puts res.text
      puts "https://twitter.com/#{res.user.screen_name}/status/#{res.id}"
      puts res.created_at
    end

    def direct_message_create(to, message)
      res = @rest_client.create_direct_message to, message
      puts res.text
      puts res.created_at
    end

    def show_status(status_id)
      res = @rest_client.status(status_id)
      line = CGI.unescapeHTML res.text
      line += " #{res.favorite_count}Fav" if res.favorite_count.to_i > 0
      line += " #{res.retweet_count}RT" if res.retweet_count.to_i > 0
      puts line.colorize(/@[a-zA-Z0-9_]+|\d+RT|\d+Fav/)
      puts "https://twitter.com/#{res.user.screen_name}/status/#{res.id}"
      puts res.created_at
    end

    def favorite(status_id)
      @rest_client.favorite status_id
    end

    def retweet(status_id)
      @rest_client.retweet status_id
    end

    def destroy_status(status_id)
      @rest_client.destroy_status status_id
    end

  end
end
