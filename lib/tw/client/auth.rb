
module Tw
  class Client
    def auth(user=nil)
      Auth.auth user
    end
  end

  class Auth

    def self.auth(user=nil)
      user = get_or_regist_user user
      Twitter.configure do |c|
        c.consumer_key = Conf['consumer_key']
        c.consumer_secret = Conf['consumer_secret']
        c.oauth_token = user['access_token']
        c.oauth_token_secret = user['access_secret']
      end
    end

    def self.get_or_regist_user(user)
      return user if user.kind_of? Hash
      if user.kind_of? String
        raise ArgumentError, "user \"#{user}\" not exists." unless Conf['users'].include? user
        return Conf['users'][user]
      end
      unless user
        return Conf['users'][ Conf['default_user'] ] if Conf['default_user']
        return regist_user
      end
    end

    def self.regist_user
      consumer = OAuth::Consumer.new(Conf['consumer_key'], Conf['consumer_secret'],
                                     :site => 'http://api.twitter.com')
      request_token = consumer.get_request_token
      puts cmd = "open #{request_token.authorize_url}"
      system cmd
      print 'input PIN Number: '
      verifier = STDIN.gets.strip
      access_token = request_token.get_access_token(:oauth_verifier => verifier)
      self.auth('access_token' => access_token.token,
                'access_secret' => access_token.secret)
      u = Twitter.user
      Conf['users'][u.screen_name] = {
        'access_token' => access_token.token,
        'access_secret' => access_token.secret,
        'id' => u.id
      }
      Conf['default_user'] = u.screen_name unless Conf['default_user']
      Conf.save
      puts "add \"@#{u.screen_name}\""
      return Conf['users'][u.screen_name]
    end

  end
end
