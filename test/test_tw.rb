require File.dirname(__FILE__) + '/test_helper.rb'

class TestTw < Test::Unit::TestCase

  def setup
    @client = Tw::Client.new
    @client.auth
  end

  def response?(arr)
    return false unless arr.kind_of? Array
    arr.each do |i|
      return false if !(i[:id].class == Fixnum and
                        i[:user] =~ /^[a-zA-Z0-9_]+$/ and
                        i[:text].kind_of? String and
                        i[:time].kind_of? Time)
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
    assert response? @client.list_timeline('shokai', 'arr')
  end
end
