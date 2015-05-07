require "minitest/autorun"
require "webmock/minitest"
require_relative "test_helper"

WebMock.disable_net_connect!(allow_localhost: true)

class TwarcTest < Minitest::Test

  def setup
    @log_location = "../data/twarc.log"
    @auth_hash = eval(File.open("../../ruby-twarc-auth.rb").read)
    File.delete(@log_location) if File.exists? @log_location
    @search_response = File.open("data/search_response.json").read
    @stream_response = File.open("data/stream_response.json").read
    @hydrate_response =File.open("data/hydrate_response.json").read
    stub_request(:get, /twitter.com\/1.1\/search/).to_return(status: 200, body: @search_response, headers: {})
    stub_request(:get, /twitter.com\/1.1\/statuses/).to_return(status: 200, body: @stream_response, headers: {})
    stub_request(:get, /twitter.com\/1.1\/lookup/).to_return(status: 200, body: @hydrate_response, headers: {})
  end

  def test_webmock
    uri = URI("https://www.twitter.com/1.1/search")
    response = Net::HTTP.get(uri)
    assert_equal response, @search_response
    uri = URI("https://www.twitter.com/1.1/statuses")
    response = Net::HTTP.get(uri)
    assert_equal response, @stream_response
    uri = URI("https://www.twitter.com/1.1/lookup")
    response = Net::HTTP.get(uri)
    assert_equal response, @hydrate_response
  end

  def test_instantiation_of_twarc_object
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: DefaultSearcher})
    assert @twarc
    assert_instance_of Twarc, @twarc
  end

  def test_basic_search
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: DefaultSearcher})
    results, max_id = @twarc.fetch(query: "vodka", count: 100)
    assert_instance_of Array, results
    assert_equal 100, results.size
    assert_equal max_id, results.last["id"]
  end

  def test_max_id
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: DefaultSearcher})
    initial_results, max_id = @twarc.fetch(query: "vodka", count: 100)
    continued_results, continued_max_id = @twarc.fetch(query: "vodka", max_id: max_id-1, count: 100)
    assert_equal 100, initial_results.size
    assert_equal 100, continued_results.size
    assert (initial_results.last["id"] > continued_results.first["id"]), "#{initial_results.last["id"]}\n#{continued_results.first["id"]}"
  end

  def test_since_id
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: DefaultSearcher})
    initial_results, max_id = @twarc.fetch(query: "vodka", count: 100)
    continued_results, continued_max_id = @twarc.fetch(query: "vodka", since_id: max_id, count: 100)
    assert_equal 100, initial_results.size
    assert_equal 100, continued_results.size
    assert (initial_results.last["id"] < continued_results.first["id"]), "#{initial_results.last["id"]}\n#{continued_results.first["id"]}"
  end

  def test_empty_search
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: DefaultSearcher})
    results, max_id = @twarc.fetch(query: (0...50).map { ('a'..'z').to_a[rand(26)] }.join, count: 100)
    assert_equal 0, results.size
    log = File.open(@log_location).readlines
    assert_equal "INFO -- : archived 0 tweets.", log.last.split("]").last.strip
  end

  def test_basic_search_logging
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: DefaultSearcher})
    @twarc.fetch(query: "mandolin", count: 100)
    log = File.open(@log_location).readlines
    assert_equal 3, log.size
    assert_equal "INFO -- : starting TwitterAPI for 'mandolin'", log[1].split("]").last.strip
    assert_equal "INFO -- : archived 100 tweets.", log.last.split("]").last.strip
  end

  def test_basic_stream
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: StreamSearcher})
    results, max_id = @twarc.fetch(query: "vodka", count: 10)
    assert_instance_of Array, results
    assert_equal 10, results.size
  end

  def test_hydrate
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: HydrateSearcher})
    ids = File.open("data/hydrate_ids.txt").readlines
    results, max_id = @twarc.fetch(ids: ids)
    assert_equal 86, results.size #some tweets don't get rehydrated
    assert_equal 501064205089665024, results.first["id"]
  end
end


