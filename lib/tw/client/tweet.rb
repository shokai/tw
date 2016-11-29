module Tw
  class Tweet
    attr_reader :id, :user, :text, :time, :fav_count, :rt_count

    def initialize(opts)
      @id = opts[:id]
      @user = opts[:user]
      @text = opts[:text]
      @time = opts[:time].getlocal
      @fav_count = opts[:fav_count]
      @rt_count = opts[:rt_count]
    end

    def to_json(*a)
      {
        :id => @id,
        :user => @user,
        :text => @text,
        :time => @time,
        :fav_count => @fav_count,
        :rt_count => @rt_count
      }.to_json(*a)
    end

    def url
      "https://twitter.com/#{user}/status/#{id}"
    end

    def to_s
      "@#{user} #{text} - #{time} #{url}"
    end

    def format(fmt)
      self.instance_eval "\"#{fmt}\""
    end
  end
end
