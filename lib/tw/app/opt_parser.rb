
module Tw::App
  class Main
    def search_word?(arg)
      arg =~ /^\?.+$/ ? arg.scan(/^\?(.+)$/)[0][0] : false
    end

    def username?(arg)
      arg =~ /^@[a-zA-Z0-9_]+$/ ? arg.scan(/^@([a-zA-Z0-9_]+)$/)[0][0] : false
    end
    
    def listname?(arg)
      arg =~ /^@[a-zA-Z0-9_]+\/[a-zA-Z0-9_]+$/ ? arg.scan(/^@([a-zA-Z0-9_]+)\/([a-zA-Z0-9_]+)$/)[0] : false
    end

    def request?(arg)
      search_word?(arg) || username?(arg) || listname?(arg)
    end
    
    def all_requests?(args)
      !args.map{|arg| request? arg}.include?(false)
    end
  end  
end
