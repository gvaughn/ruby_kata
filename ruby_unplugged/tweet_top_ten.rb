#TODO an integration test
# use something like stub in TwitterTagTracker#each_tag yields tags but
# wrapper the File#each_line, when done reset the pointer and wrap in
# while loop

require 'twitter_tag_tracker'
require 'tag_cache'
require 'webrick'
require 'yaml'

class TweetTopTen

  def initialize(credentials_filename, port)
    @credentials_filename = credentials_filename
    @port = port
  end

  def start
    validate_credentials_exist
    setup_traps

    @tag_cache = TagCache.new
    @tag_stream = TwitterTagTracker.new(YAML.load_file(@credentials_filename))
    @server = setup_endpoint

    @tag_stream_thread = start_tag_stream
    @server.start
  end

   def reset(_arg = 1)
     @tag_stream_thread.kill
     @tag_stream.close
     @tag_cache.reset
     @tag_stream.restart
     @tag_stream_thread = start_tag_stream
   end

  def quit(_arg = 1)
    @tag_stream_thread.kill
    @tag_stream.close
    @server.shutdown
  end

  private

  def setup_traps
    trap('INT',  'EXIT') #ctrl-c
    trap('TERM', 'EXIT')
    trap('HUP',  method(:reset))
    trap('QUIT', method(:quit)) #ctrl-\
  end

  def start_tag_stream
    Thread.new do
      loop do
        begin
          @tag_stream.each_tag {|tag| @tag_cache << tag}
        rescue e
          puts "rescued in reader thread: #{e.class} #{e}\n#{e.backtrace.join("\n")}"
        end
      end
    end
  end

  def setup_endpoint
    WEBrick::HTTPServer.new(Port: @port).tap do |server|
      server.mount_proc '/top10' do |request, response|
        response.body = jsonify(@tag_cache.top10)
      end
    end
  end

  def jsonify(tag_count_pairs)
    JSON.generate({'top10' => tag_count_pairs.map {|t, c| {'tag' => t, 'count' => c}}})
  end

  def validate_credentials_exist
    unless File.exist?(@credentials_filename)
      puts """
      No credentials.yml file found in current directory.
      Please copy credentials_sample.yml to credentials.yml and enter the oauth credentials.
      It would be bad security practice had I left mine in there.
      """
      exit!
    end
  end
end

