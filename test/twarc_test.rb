require "minitest/autorun"
require_relative "test_helper"

class TwarcTest < Minitest::Test

  def setup
    @log_location = "../data/twarc.log"
    @auth_hash = eval(File.open("../../ruby-twarc-auth.rb").read)
    File.delete(@log_location) if File.exists? @log_location
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

  def test_continued_search
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: DefaultSearcher})
    initial_results, max_id = @twarc.fetch(query: "vodka", count: 100)
    continued_results, continued_max_id = @twarc.fetch(query: "vodka", max_id: max_id-1, count: 100)
    assert_equal 100, initial_results.size
    assert_equal 100, continued_results.size
    assert (initial_results.last["id"] > continued_results.first["id"]), "#{initial_results.last["id"]}\n#{continued_results.first["id"]}"
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
    results, max_id = @twarc.fetch(query: "the", count: 10)
    assert_instance_of Array, results
    assert_equal 10, results.size
  end

  def test_hydrate
    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret], log: @log_location, twitter_api: HydrateSearcher})
    ids = File.open("data/hydrate_ids.txt").readlines
    results, max_id = @twarc.fetch(ids: ids)
    assert_equal 85, results.size #some tweets don't get rehydrated
    assert_equal 501064205089665024, results.first["id"]
  end
end


