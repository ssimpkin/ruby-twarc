require "minitest/autorun"
require "webmock/minitest"
require_relative "test_helper"

WebMock.disable_net_connect!(allow_localhost: true)

class RateLimiterTest < Minitest::Test

  def test_200_response
    stub_request(:get, /twitter.com/).
    with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
    to_return(status: 200, body: "200 OK", headers: {})
    uri = URI('https://twitter.com/search')
    response = Net::HTTP.get(uri)
    assert_equal "200 OK", response
    rate_limiter = RateLimiter.new(response)
    assert_equal "OK", rate_limiter.status
  end

  def test_429_response
    stub_request(:get, /twitter.com/).
    with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
    to_return(status: 200, body: "429 Too Many Requests", headers: {})
    uri = URI('https://twitter.com/search')
    response = Net::HTTP.get(uri)
    assert_equal "429 Too Many Requests", response
    rate_limiter = RateLimiter.new(response)
    # What do I expect from the rate limiter?
  end

  def test_503_response

  end
end
