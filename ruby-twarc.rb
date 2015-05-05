#!/usr/bin/env ruby

require_relative "lib/twarc.rb"
require_relative "lib/options.rb"

include Options

hash_options = setup_options

q = hash_options[:query]

if hash_options[:auth_file]
  arguments = eval(File.open(hash_options[:auth_file]).read)
  arguments[:log] = hash_options[:log]
else
  arguments = hash_options
end

arguments[:twitter_api] = hash_options[:twitter_api]

twarc = Twarc.new(arguments)

@results = twarc.fetch(query: q, count: hash_options[:count].to_i)

puts @results
