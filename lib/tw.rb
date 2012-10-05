$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'oauth'
require 'twitter'
require 'time'
require 'user_stream'
require 'yaml'
require 'time'
require 'cgi'
require 'args_parser'
require 'rainbow'
require 'tw/conf'
require 'tw/client/auth'
require 'tw/client/request'
require 'tw/client/stream'
require 'tw/client/error'

module Tw
  VERSION = '0.2.2'
  class Conf
    REQUIRE_VERSION = '0.1.0'
  end
end

