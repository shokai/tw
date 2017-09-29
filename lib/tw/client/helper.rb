
class String

  def char_length
    self.split(//u).map{|i| i.bytes.length > 1 ? 2 : 1}.reduce(:+)
  end

  def char_length_with_t_co
    Tw::Conf.update_twitter_config
    len = self.char_length
    self.scan(Regexp.new "https?://[^\s]+").each do |url|
      len += (url =~ /^https/ ? Tw::Conf['twitter_config']['short_url_length_https'] : Tw::Conf['twitter_config']['short_url_length']) - url.char_length
    end
    len
  end
end
