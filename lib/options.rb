require 'optparse'

module Options

  def setup_options
    hash_options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: ruby-twarc [options]"
      opts.on('--search [ARGV]', "Use the Twitter search API") do |v|
        hash_options[:twitter_api] = SearchAPI
        hash_options[:query] = v
      end
      opts.on('--stream [ARGV]', "Use the Twitter stream API") do |v|
        hash_options[:twitter_api] = StreamAPI
        hash_options[:query] = v
      end
      opts.on('--hydrate [ARGV]', "Rehydrate tweets from a file of ids") do |v|
        hash_options[:twitter_api] = HydrateAPI
        hash_options[:hydrate_file] = v
      end
      opts.on('--max_id', "Maximum tweet id to search for") do |v|
        hash_options[:max_id] = v
      end
      opts.on('--since_id', "Smallest id to search for") do |v|
        hash_options[:since_id] = v
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
      opts.on('--log [ARG]', "log file location") do |v|
        hash_options[:log] = v
      end
      opts.on('--count [ARG]', "number of tweets to capture") do |v|
        hash_options[:count] = v
      end
    end.parse!
    hash_options
  end
end
