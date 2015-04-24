require "minitest/autorun"
require_relative "test_helper"

class TwarcTest < Minitest::Test

  def setup

    @auth_hash = eval(File.open("../../ruby-twarc-auth.rb").read)

    @twarc = Twarc.new({consumer_key: @auth_hash[:consumer_key], consumer_secret: @auth_hash[:consumer_secret], access_token: @auth_hash[:access_token], access_token_secret: @auth_hash[:access_token_secret]})

  end

  def test_instantiation_of_twarc_object

    assert @twarc
    assert_instance_of Twarc, @twarc
    assert_equal @auth_hash[:consumer_key], @twarc.consumer_key
    assert_equal @auth_hash[:consumer_secret], @twarc.consumer_secret
    assert_equal @auth_hash[:access_token], @twarc.access_token
    assert_equal @auth_hash[:access_token_secret], @twarc.access_token_secret

  end

  def test_search
    results = @twarc.search(query: "vodka")
    assert_instance_of Array, results
    assert_equal 100, results.size
  end
end


