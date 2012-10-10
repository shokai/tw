#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'tw'

if ARGV.empty?
  STDERR.puts "ruby #{$0} hello world"
  exit 1
end

msg = ARGV.join(' ')

client = Tw::Client.new
client.auth
client.mentions.each do |m|
  puts m
end

begin
  p client.tweet msg
rescue => e
  STDERR.puts e
  exit 1
end
