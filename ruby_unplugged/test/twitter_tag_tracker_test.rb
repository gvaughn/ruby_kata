require 'twitter_tag_tracker'

describe TwitterTagTracker do

  describe "tag stream" do
    it "yields tags" do
      tags = []
      TwitterTagTracker.parse_for_tags(DATA) {|tag| tags << tag}

      tags.count.must_equal 26

      #spot check
      %w(vegan amazing HalaMadrid ابن_القيم).each do |tag|
        tags.must_include tag
      end
    end
  end

  describe "oauth signing" do
    it "adds Authorization header" do
      req = Net::HTTP::Get.new('https://example.org/path/here')
      credentials = {
        consumer_key: 'my_consumer_key',
        consumer_secret: 'consumer_secret_will_be_crypto_signed',
        access_token: 'my_access_token',
        access_token_secret: 'acccess_token_secret_will_be_crypto_signed'
      }

      auth_header = TwitterTagTracker.sign_request(req, credentials)['Authorization']

      # it's a complex header, but we can assert substrings of it
      %w(OAuth my_consumer_key my_access_token oauth_version).each do |substring|
        auth_header.must_include substring
      end
    end
  end
end

