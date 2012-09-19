
module Tw
  class Client

    def mentions
      Twitter.mentions.map{|m|
        {
          :id => m.id,
          :user => m.user.screen_name,
          :text => m.text,
          :time => m.created_at
        }
      }
    end

    def search(word)
      Twitter.search(word).results.map{|m|
        {
          :id => m.id,
          :user => m.from_user,
          :text => m.text,
          :time => m.created_at
        }
      }
    end

    def user_timeline(user)
      Twitter.user_timeline(user).map{|m|
        {
          :id => m.id,
          :user => m.user.screen_name,
          :text => m.text,
          :time => m.created_at
        }
      }
    end

    def list_timeline(user,list)
      Twitter.list_timeline(user, list).map{|m|
        {
          :id => m.id,
          :user => m.user.screen_name,
          :text => m.text,
          :time => m.created_at
        }
      }
    end

    def tweet(message)
      res = Twitter.update message
      puts res.text
      puts "http://twitter.com/#{res.user.screen_name}/status/#{res.id}"
      puts res.created_at
    end

  end
end
