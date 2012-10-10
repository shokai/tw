#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'tw'

if ARGV.empty?
  STDERR.puts "ruby #{$0} image.jpg"
  STDERR.puts "ruby #{$0} image.jpg USERNAME"
  exit 1
end

icon, user = ARGV

client = Tw::Client.new
client.auth user

File.open icon do |f|
  puts 'upload success' if Twitter.update_profile_image f
end
