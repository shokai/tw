$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'oauth'
require 'twitter'
require 'yaml'
require 'time'
require 'rainbow'
require 'tw/auth'
require 'tw/client/auth'
require 'tw/client/request'
require 'tw/conf'
require 'tw/opts'
require 'tw/app/render'

module Tw
  VERSION = '0.0.1'

  class Error < StandardError
  end

  def self.help
    open(File.expand_path '../README.rdoc', File.dirname(__FILE__)).read
  end
end
