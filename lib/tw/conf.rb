
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
      "#{ENV['HOME']}/.tw.yml"
    end

    def self.conf
      @@conf ||= (
                  res = default
                  if File.exists? conf_file
                    begin
                      open_conf_file do |f|
                        res = YAML::load f.read
                      end
                    rescue => e
                      STDERR.puts e
                      File.delete conf_file
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

    private
    def self.open_conf_file(opt=nil, &block)
      if block_given?
        yield open(self.conf_file, opt)
      else
        return open(self.conf_file, opt)
      end
    end
  end
end
