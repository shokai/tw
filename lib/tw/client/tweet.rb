module Tw
  class Tweet
    attr_reader :id, :user, :text, :time

    def initialize(opts)
      @id = opts[:id]
      @user = opts[:user]
      @text = opts[:text]
      @time = opts[:time]
    end

    def to_json(*a)
      {
        :id => @id,
        :user => @user,
        :text => @text,
        :time => @time
      }.to_json(*a)
    end

    def url
      "http://twitter.com/#{user}/status/#{id}"
    end

    def to_s
      "@#{user} #{text} - #{time} #{url}"
    end

    def format(fmt)
      self.instance_eval "\"#{fmt}\""
    end
  end
end
