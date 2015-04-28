require "oauth"

class AccessToken

  def initialize(credentials)
    @c = credentials
    @access_token = prepare_access_token
  end

  def request(method, url)
    @access_token.request(method, url)
  end

  private

  def prepare_access_token
    consumer = OAuth::Consumer.new(@c.consumer_key, @c.consumer_secret, site_info)
    OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def token_hash
    {oauth_token: @c.access_token, oauth_token_secret: @c.access_token_secret}
  end

  def site_info
    {site: "https://api.twitter.com", scheme: :header}
  end

end
