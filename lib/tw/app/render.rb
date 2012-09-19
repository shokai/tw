
module Tw
  class Render
    def self.color_code(str)
      colors = Sickill::Rainbow::TERM_COLORS.keys - [:default, :black, :white]
      n = str.each_byte.map{|c| c.to_i}.inject{|a,b|a+b}
      return colors[n%colors.size]
    end
    
    def self.display(hash)
      hash.flatten.sort{|a,b|
        a[:id] <=> b[:id]
      }.uniq.each{|m|
        line = "#{m[:time].strftime '[%m/%d %a] (%H:%M:%S)'} @#{m[:user]} : #{m[:text]}"
        puts line.split(/(@[a-zA-Z0-9_]+)/).map{|term|
          if term =~ /@[a-zA-Z0-9_]+/
            term = term.color(color_code term).bright.underline
          end
          term
        }.join('')
      }
    end
  end
end
