require "json"
require "logger"
require_relative "./credentials"
require_relative "./twitter_apis"

class Twarc

  attr_reader :consumer_key, :consumer_secret, :access_token, :access_token_secret
  attr_writer :twitter_api

  def initialize(arguments = {})
    @twitter_api = arguments[:twitter_api].new(Credentials.new(arguments))
    @@logger = Logger.new(arguments[:log])
    @results = []
  end

  def fetch(search_arguments = {})
    @@logger.info("starting #{search_arguments[:mode]} for #{search_arguments[:query]}")
    @results = @twitter_api.search(search_arguments)
    @@logger.info("archived #{@results.size} tweets.")
    return @results, max_id
  end

  def max_id
    @results.size > 0 ? @results.last["id"] : 0
  end
end
