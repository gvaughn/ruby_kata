require 'oauth'
require 'json'

class TwitterTagTracker
  TWITTER_API_URL = "https://stream.twitter.com/1.1/statuses/sample.json"
  TAG_REGEX = /\B#(\p{Word}+)/

  def initialize(credentials)
    @credentials = credentials
  end

  def each_tag(&blk)
    uri = URI(TWITTER_API_URL)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      http.request(sign_request(request)) do |response|
        response.read_body do |str|
          parse_for_tags(str, &blk)
        end
      end
    end
  end

  # TODO private

  def parse_for_tags(io)
    io.each_line do |line|
      begin
        JSON.parse(line).fetch('text', '').scan(TAG_REGEX).each {|tag| yield tag.first}
      rescue JSON::ParserError
        next
      end
    end
  end

  def sign_request(req)
    consumer = OAuth::Consumer.new(@credentials.fetch(:consumer_key), @credentials.fetch(:consumer_secret),
                                   { :site => "https://stream.twitter.com", :scheme => :header })

    # now create the access token object from passed values
    token_hash = { :oauth_token => @credentials.fetch(:access_token),
                   :oauth_token_secret => @credentials.fetch(:access_token_secret) }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)

    access_token.sign!(req)
    req
  end
end

