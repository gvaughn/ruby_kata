require 'oauth'
require 'json'

# This wrappers the oauth and https connection logic with tag parsing
# logic and provides the caller with a simplified streaming #each_tag method
class TwitterTagTracker
  TWITTER_API_URL = "https://stream.twitter.com/1.1/statuses/sample.json"
  TAG_REGEX = /\B#(\p{Word}+)/

  # credentials is a Hash containing 4 oauth required values,
  #  consumer_key, consumer_secret, access_token, and access_token_secret
  #  expecting those as symbol keys
  def initialize(credentials)
    @credentials = credentials
    @stop = false
  end

  # Repeatedly yields to the required block a String tag
  def each_tag(&blk)
    open_stream {|str| parse_for_tags(str, &blk)}
  rescue SocketError => se
    unless @stop
      puts "connection problem, \"#{se}\" retrying in 10 seconds ..."
      sleep 10
      retry
    end
  end

  # Closes the stream from twitter
  def close
    puts "closing twitter stream"
    @stop = true
    @connection.finish if @connection
  rescue IOError
    #raised if not already started, so no action
  end

  # Enables the connection to twitter to restart
  def restart
    @stop = false
  end

  private

  def open_stream(&blk)
    return "" if @stop
    uri = URI(TWITTER_API_URL)
    @connection = Net::HTTP.new(uri.host, uri.port)
    @connection.use_ssl = true
    @connection.open_timeout = 5
    request = sign_request(Net::HTTP::Get.new(uri))

    puts "opening twitter stream"
    @connection.request(request) do |response|
      unless response.code == 200
        raise RuntimeError, "#{response.code} from twitter. Bad credentials maybe."
      end
      response.read_body(&blk)
    end
  end

  def parse_for_tags(io)
    io.each_line do |line|
      begin
        JSON.parse(line).fetch('text', '').scan(TAG_REGEX) {|(tag)| yield tag}
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

