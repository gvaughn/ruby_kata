require 'oauth'
require 'json'

class TwitterTagTracker
  TWITTER_API_URL = "https://stream.twitter.com/1.1/statuses/sample.json"
  TAG_REGEX = /\B#(\p{Word}+)/

  def initialize(credentials)
    @credentials = credentials
  end

  def each_tag(&blk)
    open_stream {|str| parse_for_tags(str, &blk)}
  rescue SocketError => e
    puts "connection problem, \"#{e}\" retrying in 10 seconds ..."
    sleep 10
    retry
  end

  private

  def open_stream(&blk)
    uri = URI(TWITTER_API_URL)
    connection = Net::HTTP.new(uri.host, uri.port)
    connection.use_ssl = true
    request = sign_request(Net::HTTP::Get.new(uri))

    connection.request(request) do |response|
      response.read_body(&blk)
    end
  end

  def parse_for_tags(io)
    io.each_line do |line|
      begin
        # TODO try to figure out why each tag is arrayed
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

