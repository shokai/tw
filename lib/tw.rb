$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'backports'
require 'oauth'
require 'twitter'
require 'yaml'
require 'time'
require 'args_parser'
require 'rainbow'
require 'tw/conf'
require 'tw/client/auth'
require 'tw/client/request'
require 'tw/client/error'

module Tw
  VERSION = '0.0.3'
end
