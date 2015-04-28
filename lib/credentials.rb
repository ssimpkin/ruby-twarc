class Credentials
  attr_reader :consumer_key, :consumer_secret, :access_token, :access_token_secret
  def initialize(arguments = {})
    @consumer_key = arguments[:consumer_key]
    @consumer_secret = arguments[:consumer_secret]
    @access_token = arguments[:access_token]
    @access_token_secret = arguments[:access_token_secret]
  end

  def keys
    [@consumer_key, @consumer_secret, @access_token, @access_token_secret]
  end
end
