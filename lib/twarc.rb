require "json"
require "logger"
require_relative "./credentials"
require_relative "./twitter_apis"

class Twarc

  attr_reader :consumer_key, :consumer_secret, :access_token, :access_token_secret
  attr_writer :twitter_api

  def initialize(arguments = {})
    @twitter_api = TwitterAPI.new(Credentials.new(arguments), arguments[:twitter_api])
    @@logger = Logger.new(arguments[:log])
    @results = []
  end

  def fetch(search_arguments = {})
    @@logger.info("starting #{@twitter_api.class} for '#{search_arguments[:query]}'")
    @results, max_id = @twitter_api.search(search_arguments)
    @@logger.info("archived #{@results.size} tweets.")
    return @results, max_id
  end
end
