
module Tw::App
  class Render
    def self.color_code(str)
      colors = Sickill::Rainbow::TERM_COLORS.keys - [:default, :black, :white]
      n = str.each_byte.map{|c| c.to_i}.inject{|a,b|a+b}
      return colors[n%colors.size]
    end
    
    def self.display(arr, format)
      arr = [arr] unless arr.kind_of? Array
      arr.flatten.inject({}){
        |h,i| h[i.id]=i; h
      }.values.sort{|a,b|
        a.id <=> b.id
      }.each{|m|
        puts case format
             when 'text'
               user = m.user.kind_of?(Hash) ? "@#{m.user[:from]} > @#{m.user[:to]}" : "@#{m.user}"
               line = "#{m.time.strftime '[%m/%d %a] (%H:%M:%S)'} #{user} : #{CGI.unescapeHTML m.text}"
               line.colorize(/@[a-zA-Z0-9_]+/)
             when 'json'
               m.to_json
             else
               m.to_s format
             end
      }
    end
  end
end
