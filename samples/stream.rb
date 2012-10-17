#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'tw'

user = ARGV.shift
client = Tw::Client::Stream.new user

loop do
  begin
    client.user_stream do |m|
      puts m
    end
  rescue StandardError, Timeout::Error => e
    puts e.message
  end
end
