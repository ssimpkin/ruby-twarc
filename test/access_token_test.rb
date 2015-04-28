require "minitest/autorun"
require_relative "test_helper"

class AccessTokenTest < Minitest::Test

  def setup
    auth_file_hash = eval(File.open("data/ruby-twarc-auth.rb").read)
    credentials = Credentials.new(auth_file_hash)
    @access_token = AccessToken.new(credentials)
  end

  def test_access_token_request
    url = "https://api.twitter.com/1.1/search/tweets.json?q=vodka&count=100"
    results = @access_token.request(:get, url)
    assert_equal eval(results.body), {"errors":[{"code":89,"message":"Invalid or expired token."}]}
  end
end
