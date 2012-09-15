
module Tw
  class Opts
    def self.search_word?(str)
      str =~ /^\?.+$/ ? str.scan(/^\?(.+)$/)[0][0] : false
    end
    
    def self.username?(str)
      str =~ /^@[a-zA-Z0-9_]+$/ ? str.scan(/^@([a-zA-Z0-9_]+)$/)[0][0] : false
    end
    
    def self.listname?(str)
      if str =~ /^@[a-zA-Z0-9_]+\/[a-zA-Z0-9_]+$/
        return str.scan(/^@([a-zA-Z0-9_]+)\/([a-zA-Z0-9_]+)$/).first
      end
      false
    end
    
    def self.cmd?(str)
      search_word?(str) || username?(str) || listname?(str)
    end
    
    def self.all_cmds?(argv)
      argv.map{|arg| cmd? arg}.count(false) < 1
    end
  end
end
