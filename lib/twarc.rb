require "json"
require "logger"
require "tweetstream"
require_relative "./credentials"
require_relative "./access_token"

TWITTER_SEARCH = "https://api.twitter.com/1.1/search/tweets.json"

class Twarc

  attr_reader :consumer_key, :consumer_secret, :access_token, :access_token_secret

  def initialize(arguments = {})
    @c = Credentials.new(arguments)
    @@logger = Logger.new(arguments[:log])
    @results = []
  end

  def fetch(search_arguments = {})
    @query = search_arguments[:query]
    @count = search_arguments[:count]
    @since_id = search_arguments[:since_id]
    @@logger.info("starting #{search_arguments[:mode]} for #{@query}")
    self.send(search_arguments[:mode])
    @@logger.info("archived #{@results.size} tweets.")
    return @results, max_id
  end

  def max_id
    @results.size > 0 ? @results.last["id"] : 0
  end

  #alias_method :since_id, :max_id

  private

  def twitter_url
    "#{TWITTER_SEARCH}?q=#{@query}&count=#{@count}&max_id=#{max_id}&since_id=#{@since_id}"
  end

  def twitter_response(url)
    access_token = AccessToken.new(@c)
    JSON.parse(access_token.request(:get, url).body)["statuses"]
  end

  def track
    TweetStream::Client.new.track(@query) do |status|
      if @results.size < @count
        @results << status.to_h
      else
        break
      end
    end
  end

  def configure_tweetstream
    TweetStream.configure do |config|
      config.consumer_key, config.consumer_secret, config.oauth_token, config.oauth_token_secret = @c.keys
      config.auth_method = :oauth
    end
  end

  def search
    @results = twitter_response(twitter_url)
  end

  def stream
    configure_tweetstream
    track
  end
end
