$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'oauth'
require 'twitter'
require 'time'
require 'yaml'
require 'time'
require 'cgi'
require 'json'
require 'args_parser'
require 'rainbow'
require 'parallel'
require 'launchy'
require 'tw/conf'
require 'tw/client/auth'
require 'tw/client/request'
require 'tw/client/tweet'
require 'tw/client/stream'
require 'tw/client/error'
require 'tw/client/helper'
require 'tw/version'

module Tw
  class Conf
    REQUIRE_VERSION = '0.1.0'
  end
end
