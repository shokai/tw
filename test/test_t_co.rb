# -*- coding: utf-8 -*-
require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestTCo < MiniTest::Unit::TestCase

  def setup
    @client = Tw::Client.new
    @client.auth
  end

  def test_t_co_char_length
    msg = "blog書いた → http://shokai.org/blog/archives/6513"
    assert msg.char_length > msg.char_length_with_t_co
  end
end
