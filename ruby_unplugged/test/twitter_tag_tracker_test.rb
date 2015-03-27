require 'twitter_tag_tracker'
#TODO don't use the suite's DATA

describe TwitterTagTracker do

  describe "tag stream" do
    it "yields tags" do
      #TODO test at the each_tag level
      tags = []
      ttt = TwitterTagTracker.new({})
      ttt.parse_for_tags(DATA) {|tag| tags << tag}

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

      ttt = TwitterTagTracker.new(credentials)
      auth_header = ttt.sign_request(req)['Authorization']

      # it's a complex header, but we can assert substrings of it
      %w(OAuth my_consumer_key my_access_token oauth_version).each do |substring|
        auth_header.must_include substring
      end
    end
  end
end

