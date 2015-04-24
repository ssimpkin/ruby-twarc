#!/usr/bin/env ruby

require_relative "lib/twarc.rb"
require 'optparse'

hash_options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby-twarc [options]"
  opts.on('-m [ARG]', '--method [ARG]', "search or stream") do |v|
    hash_options[:method] = v
  end
  opts.on('-f [ARG]', '--file [ARG]', "specify an auth file") do |v|
    hash_options[:file] = v
  end
  opts.on('-k', '--key [ARG]', "your consumer key") do |v|
    hash_options[:consumer_key] = v
  end
  opts.on('-s', '--secret [ARG]', "your consumer secret") do |v|
    hash_options[:consumer_secret] = v
  end
  opts.on('-t', '--token [ARG]', "your access token") do |v|
    hash_options[:access_token] = v
  end
  opts.on('-x', '--token_secret [ARG]', "your secret token") do |v|
    hash_options[:access_token_secret] = v
  end
  opts.on('-q', '--query [ARG]', "query string") do |v|
    hash_options[:query] = v
  end
end.parse!

method = hash_options[:method]
q = hash_options[:query]

if hash_options[:file]
  auth_info = eval(File.open(hash_options[:file]).read) if hash_options[:file]
else
  auth_info = hash_options.tap{ |h| h.delete(:method); h.delete(:file) }
end

twarc = Twarc.new(auth_info)

if method == "search"
  @results = twarc.search(query: q)
else
  puts "Streaming not yet implemented."
  exit
end

puts @results


