require "minitest/autorun"
require_relative "test_helper"

class CredentialsTest < Minitest::Test

  def setup
    @auth_file_hash = eval(File.open("data/ruby-twarc-auth.rb").read)
    @credentials = Credentials.new(@auth_file_hash)
  end

  def test_credentials
    assert_equal @credentials.consumer_key, @auth_file_hash[:consumer_key]
    assert_equal @credentials.consumer_secret, @auth_file_hash[:consumer_secret]
    assert_equal @credentials.access_token, @auth_file_hash[:access_token]
    assert_equal @credentials.access_token_secret, @auth_file_hash[:access_token_secret]
  end

  def test_keys
    assert_equal @auth_file_hash.values, @credentials.keys
  end
end
