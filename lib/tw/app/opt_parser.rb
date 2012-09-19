
module Tw::App
  class OptParser

    def self.init
      @@argv = []
    end
    init

    def self.argv
      @@argv
    end

    def self.parse(argv)
      self.init
      Tw::Opts.init
      argv.each do |arg|
        k,v = param?(arg)
        unless k
          self.argv.push arg
          next
        end
        Tw::Opts[k] = v
      end
    end

    def self.search_word?(arg)
      arg =~ /^\?.+$/ ? arg.scan(/^\?(.+)$/)[0][0] : false
    end

    def self.username?(arg)
      arg =~ /^@[a-zA-Z0-9_]+$/ ? arg.scan(/^@([a-zA-Z0-9_]+)$/)[0][0] : false
    end
    
    def self.listname?(arg)
      arg =~ /^@[a-zA-Z0-9_]+\/[a-zA-Z0-9_]+$/ ? arg.scan(/^@([a-zA-Z0-9_]+)\/([a-zA-Z0-9_]+)$/)[0] : false
    end

    def self.param?(arg)
      if arg =~ /^--+[^=]+=[^=]+$/
        return arg.scan(/^--+([^=]+)=([^=]+)$/)[0]
      elsif arg =~ /^--+[^-].*$/
        return [arg.scan(/^--+([^-].*)$/)[0][0], true]
      end
      false
    end

    def self.request?(arg)
      search_word?(arg) || username?(arg) || listname?(arg)
    end
    
    def self.all_requests?(argv=self.argv)
      argv.map{|arg| request? arg}.count(false) < 1
    end
  end  
end
