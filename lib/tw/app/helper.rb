
class String
  def colorize(pattern)
    self.split(/(#{pattern})/).map{|term|
      if term =~ /#{pattern}/
        term = term.color(Tw::App::Render.color_code term).bright.underline
      end
      term
    }.join('')
  end
end
