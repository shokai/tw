
module Tw
  class Conf

    def self.default
      {
        'version' => Tw::VERSION,
        'consumer_key' => 'AYhhkOC8H2yTZyelz3uw',
        'consumer_secret' => '28Ba8YyFDSPgoCYAmH5ANqOmT6qVS8gIhKnUiDbIpU',
        'default_user' => nil,
        'users' => {}
      }
    end

    def self.[](key)
      ENV[key] || conf[key]
    end

    def self.[]=(key,value)
      conf[key] = value
    end

    def self.conf_file
      @@conf_file ||= "#{ENV['HOME']}/.tw.yml"
    end

    def self.conf_file=(fpath)
      @@conf_file = fpath
    end

    def self.conf
      @@conf ||= (
                  res = default
                  if File.exist? self.conf_file
                    begin
                      data = nil
                      self.open_conf_file do |f|
                        data = YAML::load f.read
                      end
                      if data['version'] < REQUIRE_VERSION
                        puts "This is tw version #{Tw::VERSION}."
                        puts "Your config file is old ("+data['version']+"). Reset tw settings?"
                        puts "[Y/n]"
                        res = data if STDIN.gets =~ /^n/i
                      else
                        res = data
                      end
                    rescue => e
                      STDERR.puts e
                      File.delete self.conf_file
                    end
                  end
                  res
                  )
    end

    def self.to_yaml
      self.conf.to_yaml
    end

    def self.save
      open_conf_file('w+') do |f|
        f.write conf.to_yaml
      end
    end

    def self.update_twitter_config(force_update=false)
      if self['twitter_config'].kind_of? Hash and
          self['twitter_config']['last_updated_at']+60*60*24 > Time.now.to_i and
          !force_update
        return
      end
      self['twitter_config'] = {}
      self['twitter_config']['short_url_length'] = Tw::Client.client.configuration.short_url_length
      self['twitter_config']['short_url_length_https'] = Tw::Client.client.configuration.short_url_length_https
      self['twitter_config']['last_updated_at'] = Time.now.to_i
      self.save
    end

    private
    def self.open_conf_file(opt=nil, &block)
      if block_given?
        yield open(self.conf_file, opt)
      else
        return open(self.conf_file, opt)
      end
      File.chmod 0600, self.conf_file if File.exist? self.conf_file
    end
  end
end
