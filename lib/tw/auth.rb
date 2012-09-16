
module Tw
  class Client

    def initialize
      if Conf['users'].empty? or !Conf['default_user'] or Opts.params['user:add']
        add_user
      else
        name = Opts.params['user'] || Conf['default_user']
        unless Conf['users'].include? name
          raise ArgumentError, "user \"#{name}\" not exists.
% tw --user:add"
        end
        auth Conf['users'][name]
      end
    end

    def auth(user)
      Twitter.configure do |c|
        c.consumer_key = Conf['consumer_key']
        c.consumer_secret = Conf['consumer_secret']
        c.oauth_token = user['access_token']
        c.oauth_token_secret = user['access_secret']
      end
    end

    def add_user
      consumer = OAuth::Consumer.new(Conf['consumer_key'], Conf['consumer_secret'],
                                     :site => 'http://twitter.com')
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
    end

  end
end
