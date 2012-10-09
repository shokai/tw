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

    def to_s(format)
      self.instance_eval "\"#{format}\""
    end
  end
end
