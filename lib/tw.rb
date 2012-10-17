$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

$KCODE = 'u' if RUBY_VERSION < '1.9'
require 'oauth'
require 'twitter'
require 'twitter-text'
require 'time'
require 'user_stream'
require 'yaml'
require 'time'
require 'cgi'
require 'json'
require 'args_parser'
require 'rainbow'
require 'parallel'
require 'tw/conf'
require 'tw/client/auth'
require 'tw/client/request'
require 'tw/client/tweet'
require 'tw/client/stream'
require 'tw/client/error'
require 'tw/client/helper'

module Tw
  VERSION = '0.3.3'
  class Conf
    REQUIRE_VERSION = '0.1.0'
  end
end
