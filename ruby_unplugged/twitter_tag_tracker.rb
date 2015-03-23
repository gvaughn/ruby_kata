require 'oauth'
require 'json'

module TwitterTagTracker
  class TagStream
    TAG_REGEX = /\B#(\p{Word}+)/

    def initialize(io)
      @io = io
    end

    def each_tag
      raise "Requires a block" unless block_given?

      @io.each_line do |line|
        begin
          JSON.parse(line).fetch('text', '').scan(TAG_REGEX).each {|tag| yield tag.first}
        rescue JSON::ParserError
          next
        end
      end
    end
  end

  # def doit
  #   p = {consumer_key: 'CLaagGV6Xdc6qeHJPQpJXZPBd',
  #        consumer_secret: 'ArWcF8HloljHuhcYU8mBJdkatwGwIx5WrZOapeXAV9H3OxZfO9',
  #        access_token: '15373276-H5c9DYVj8zhtb3wyXnlTCkFIoGzbh5ESgaPbktk2S',
  #        access_token_secret: 'aq3EDMFwmYYnTCMn9xPcDOUTqgeYTrF1gwKQF2upYPxEr'
  #   }
  #   req1 = Net::HTTP.new('dev.twitter.com', 443)
  #   req2 = sign_request(req1, p)
  #   resp = req2.get('/streaming/reference/get/statuses/sample')
  #   puts resp
  # end

  # def sign_request(req, params)
  #   consumer = OAuth::Consumer.new(params.fetch(:consumer_key), params.fetch(:consumer_secret), 
  #                                  { :site => "https://dev.twitter.com", :scheme => :header })
  #   puts "consumer: #{consumer.inspect}"

  #   # now create the access token object from passed values
  #   token_hash = { :oauth_token => params.fetch(:access_token), 
  #                  :oauth_token_secret => params.fetch(:access_token_secret) }
  #   access_token = OAuth::AccessToken.from_hash(consumer, token_hash)

  #   access_token.sign!(req)
  # end

# # Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
  # def prepare_access_token(oauth_token, oauth_token_secret)
  #     consumer = OAuth::Consumer.new("CLaagGV6Xdc6qeHJPQpJXZPBd", "ArWcF8HloljHuhcYU8mBJdkatwGwIx5WrZOapeXAV9H3OxZfO9", { :site => "https://stream.twitter.com", :scheme => :header })
       
  #     # now create the access token object from passed values
  #     token_hash = { :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret }
  #     access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
   
  #     return access_token
  # end

  # # Exchange our oauth_token and oauth_token secret for the AccessToken instance.
  # def doit2
  #   access_token = prepare_access_token("15373276-H5c9DYVj8zhtb3wyXnlTCkFIoGzbh5ESgaPbktk2S", "aq3EDMFwmYYnTCMn9xPcDOUTqgeYTrF1gwKQF2upYPxEr")
     
  #   # use the access token as an agent to get the home timeline
  #   response = access_token.request(:get, "https://stream.twitter.com/1.1/statuses/sample.json")
  #   puts response.body
  # end
end
