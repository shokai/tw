
module Tw
  class Opts
    
    def self.init
      @@params = {}
    end
    init

    def self.inspect
      @@params
    end

    def self.keys
      @@params.keys
    end

    def self.[](key)
      @@params[key]
    end

    def self.[]=(key,value)
      @@params[key] = value
    end

  end
end
