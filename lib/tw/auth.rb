
module Tw
  class Client

    def initialize
      if !Conf['access_token'] or !Conf['access_secret']
        consumer = OAuth::Consumer.new(Conf['consumer_key'], Conf['consumer_secret'],
                                       :site => 'http://twitter.com')
        begin
          request_token = consumer.get_request_token
          puts "open #{request_token.authorize_url}"
          system "open #{request_token.authorize_url}"
          print 'input PIN Number: '
          oauth_verifier = gets.strip
          access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)
          Conf['access_token'] = access_token.token
          Conf['access_secret'] = access_token.secret
        rescue => e
          raise Error.new "#{e.to_s}\ncheck config file(#{Conf.conf_file}) and twitter.com status."
        end
        Conf.open_conf_file('w+'){|f|
          f.puts Conf.to_yaml
        }
      end

      Twitter.configure do |c|
        c.consumer_key = Conf['consumer_key']
        c.consumer_secret = Conf['consumer_secret']
        c.oauth_token = Conf['access_token']
        c.oauth_token_secret = Conf['access_secret']
      end
    end

  end
end
