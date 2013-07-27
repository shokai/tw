
module Tw::App
  class Main
    def username?(arg)
      arg =~ /^@[a-zA-Z0-9_]+$/ ? arg.scan(/^@([a-zA-Z0-9_]+)$/)[0][0] : false
    end
    
    def listname?(arg)
      arg =~ /^@[a-zA-Z0-9_]+\/[a-zA-Z0-9_-]+$/ ? arg.scan(/^@([a-zA-Z0-9_]+)\/([a-zA-Z0-9_-]+)$/)[0] : false
    end

    def request?(arg)
      username?(arg) or listname?(arg)
    end
    
    def all_requests?(args)
      !args.map{|arg| request? arg}.include?(false)
    end
  end  
end
