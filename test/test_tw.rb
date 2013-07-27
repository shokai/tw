require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestTw < MiniTest::Test

  def setup
    @client = Tw::Client.new
    @client.auth
  end

  def user?(str)
    return false unless str.kind_of? String
    str =~ /^[a-zA-Z0-9_]+$/
  end

  def response?(arr)
    return false unless arr.kind_of? Array
    arr.each do |i|
      return false if !(i.id.class == Fixnum and
                        (user? i.user or (user? i.user[:to] and user? i.user[:from])) and
                        i.text.kind_of? String and
                        i.time.kind_of? Time)
    end
    return true
  end
  
  def test_mentions
    assert response? @client.mentions
  end

  def test_home_timeline
    assert response? @client.home_timeline
  end

  def test_search
    assert response? @client.search('ruby')
  end

  def test_user_timeline
    assert response? @client.user_timeline 'shokai'
  end

  def test_list_timeline
    assert response? @client.list_timeline('shokai', 'tw-user')
  end

  def test_direct_message
    assert response? @client.direct_messages
  end
end
