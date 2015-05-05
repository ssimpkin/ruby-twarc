require "tweetstream"
require_relative "./access_token"

class TwitterAPI

  def initialize(credentials, searcher = DefaultSearcher)
    @credentials = credentials
    @searcher = searcher.new
  end

  def search(search_arguments)
    @searcher.search(search_arguments, access_token, @credentials)
  end

  private

  def access_token
    @access_token ||= AccessToken.new(@credentials)
  end

end

class BasicSearcher
  def search(arguments, access_token, credentials)
    results = []
    begin
      results = parsed_json(access_token, arguments)
    rescue Exception => e
      puts "ruby-twarc: #{e}"
    end
    if results.size > 0
      return results, results.last["id"]
    else
      return results, 0
    end
  end
end

class DefaultSearcher < BasicSearcher

  private

  def parsed_json(access_token, arguments)
    JSON.parse(access_token.request(:get, url(arguments)).body)["statuses"]
  end

  def endpoint
    "https://api.twitter.com/1.1/search/tweets.json"
  end

  def url(args)
    "#{endpoint}?q=#{args[:query]}&count=#{args[:count]}&max_id=#{args[:max_id]}&since_id=#{args[:since_id]}"
  end

end

class HydrateSearcher < BasicSearcher

  private

  def parsed_json(access_token, arguments)
    JSON.parse(access_token.request(:get, url(arguments)).body)
  end


  def endpoint
    "https://api.twitter.com/1.1/statuses/lookup.json"
  end

  def url(args)
    "#{endpoint}?id=#{args[:ids].join(",")}"
  end
end

class StreamSearcher

 def search(arguments, access_token, credentials)
    configure_tweetstream(credentials)
    results = []
    TweetStream::Client.new.track(arguments[:query]) do |status|
      if arguments[:count] > 0
        while results.size < arguments[:count]
          puts status.to_h
          results << status.to_h
        end
        break
      else
        while true
          puts status.to_h
          trap("INT"){ exit }
        end
      end
    end
    if results.size > 0
      return results, results.last["id"]
    else
      return results, 0
    end
  end

  private

  def configure_tweetstream(credentials)
    TweetStream.configure do |config|
      config.consumer_key, config.consumer_secret, config.oauth_token, config.oauth_token_secret = credentials.keys
      config.auth_method = :oauth
    end
  end

end
