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

twarc = Twarc.new(arguments)

if hash_options[:search]
  @results = twarc.search(query: q)
elsif hash_options[:stream]
  @results = twarc.stream(query: q)
else
  puts "Hydrate not yet implemented."
end

puts @results
