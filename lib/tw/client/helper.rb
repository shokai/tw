
class String
  def char_length_with_t_co
    Tw::Conf.update_twitter_config
    len = self.char_length
    Twitter::Extractor.extract_urls(self).each do |url|
      len += (url =~ /^https/ ? Tw::Conf['twitter_config']['short_url_length_https'] : Tw::Conf['twitter_config']['short_url_length']) - url.char_length
    end
    len
  end
end
