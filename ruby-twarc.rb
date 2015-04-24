#!/usr/bin/env ruby

require_relative "lib/twarc.rb"
require 'optparse'

hash_options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby-twarc [options]"
  opts.on('--search', "Use the Twitter search API") do |v|
    hash_options[:search] = v
  end
  opts.on('--stream', "Use the Twitter stream API") do |v|
    hash_options[:stream] = v
  end
  opts.on('--hydrate', "Rehydrate tweets from a file of ids") do |v|
    hash_options[:stream] = v
  end
  opts.on('--max_id', "Maximum tweet id to search for") do |v|
    hash_options[:stream] = v
  end
  opts.on('--since_id', "Smallest id to search for") do |v|
    hash_options[:stream] = v
  end
  opts.on('--auth_file [ARG]', "specify an auth file") do |v|
    hash_options[:auth_file] = v
  end
  opts.on('--consumer_key', "your consumer key") do |v|
    hash_options[:consumer_key] = v
  end
  opts.on('--consumer_secret', "your consumer secret") do |v|
    hash_options[:consumer_secret] = v
  end
  opts.on('--access_token', "your access token") do |v|
    hash_options[:access_token] = v
  end
  opts.on('--access_token_secret', "your secret token") do |v|
    hash_options[:access_token_secret] = v
  end
  opts.on('--query [ARG]', "query string") do |v|
    hash_options[:query] = v
  end
  opts.on('--log [ARG]', "log file location") do |v|
    hash_options[:log] = v
  end
end.parse!

q = hash_options[:query]
if hash_options[:auth_file]
  arguments = eval(File.open(hash_options[:auth_file]).read)
  arguments[:log] = hash_options[:log]
else
  arguments = hash_options
end

twarc = Twarc.new(arguments)

if hash_options[:search]
  @results = twarc.search(query: q)
elsif hash_options[:stream]
  puts "Streaming not yet implemented."
  exit
else
  puts "Hydrate not yet implemented."
end

puts @results


