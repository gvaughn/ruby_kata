require 'minitest/autorun'
require 'twitter_tag_tracker'

describe TwitterTagTracker do

  subject {TwitterTagTracker.new(credentials)}
  let(:credentials) {
      { consumer_key: 'my_consumer_key',
        consumer_secret: 'consumer_secret_will_be_crypto_signed',
        access_token: 'my_access_token',
        access_token_secret: 'acccess_token_secret_will_be_crypto_signed'
      }
  }
  let(:sample_stream) {File.open(File.expand_path('../sample_stream.json', __FILE__))}

  it "#each_tag yields tags" do
    tags = []
    subject.stub(:open_stream, true, sample_stream) do
      subject.each_tag {|tag| tags << tag}
    end

    tags.count.must_equal 26

    #spot check
    %w(bakery amazing HalaMadrid ابن_القيم).each do |tag|
      tags.must_include tag
    end
  end

  it "can #close" do
    @mock_connection = MiniTest::Mock.new
    @mock_connection.expect(:finish, true)
    # this is heavy handed. I'm tempted not to write this test at all
    subject.instance_variable_set(:@connection, @mock_connection)
    subject.close
  end

  it "adds oauth Authorization header" do
    req = Net::HTTP::Get.new('https://example.org/path/here')
    # normally I prefer not to :send, but this is tricky enough to test in isolation
    # but I still prefer to leave the method private
    signed_req = subject.send(:sign_request, req)
    auth_header = signed_req['Authorization']

    # it's a complex header, but we can assert substrings of it
    %w(OAuth my_consumer_key my_access_token oauth_version).each do |substring|
      auth_header.must_include substring
    end
  end
end

