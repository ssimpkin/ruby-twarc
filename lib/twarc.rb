require "json"
require "oauth"
require "logger"

TWITTER_SEARCH = "https://api.twitter.com/1.1/search/tweets.json"
TWITTER_STREAM = "https://stream.twitter.com/1.1/statuses/filter.json"

class Twarc

  attr_reader :consumer_key, :consumer_secret, :access_token, :access_token_secret

  def initialize(arguments = {})
    @consumer_key = arguments[:consumer_key]
    @consumer_secret = arguments[:consumer_secret]
    @access_token = arguments[:access_token]
    @access_token_secret = arguments[:access_token_secret]
    @@logger = Logger.new(arguments[:log])
  end

  def search(search_arguments = {})
    @search_arguments = search_arguments
    @@logger.info("starting search for #{query}")
    @results = twitter_response(twitter_url)
    @@logger.info("archived #{@results.size} tweets.")
    @results
  end

  def max_id
    if @results
      return @results.size > 0 ? @results.last["id_str"] : 0
    else
      @search_arguments[:max_id]
    end
  end

  private

  def twitter_url
    since_id = @search_arguments[:since_id] || ""
    "#{TWITTER_SEARCH}?q=#{query}&count=100&max_id=#{max_id}&since_id=#{since_id}"
  end

  def query
    @search_arguments[:query]
  end

  def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {site: "https://api.twitter.com", scheme: :header})
    token_hash = {oauth_token: oauth_token, oauth_token_secret: oauth_token_secret}
    OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def twitter_response(url)
    access_token = prepare_access_token(@access_token, @access_token_secret)
    JSON.parse(access_token.request(:get, url).body)["statuses"]
  end
end
