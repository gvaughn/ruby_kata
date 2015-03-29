require 'tag_cache'
require 'webrick'

# This class coordinates multithreaded interactions between
# TwitterTagStream, TagCache, and WEBrick as well as signal handlers.
class TweetTopTen

  # streamer is a TwitterTagStream or appropriate ducktype of it
  # port specifies where WEBrick is listening
  def initialize(streamer, port)
    @tag_stream = streamer
    @port = port
  end

  # starts up the connecting threads of the system
  def start
    setup_traps

    @tag_cache = TagCache.new
    @server = setup_endpoint

    @tag_stream_thread = start_tag_stream
    @server.start
  end

  # closes and reopens the twitter stream plus clears all statistics
   def reset(_arg = 1)
     @tag_stream_thread.kill
     @tag_stream.close
     @tag_cache.reset
     @tag_stream.restart
     @tag_stream_thread = start_tag_stream
   end

   # graceful shutdown
   # may be delayed by closing of twitter stream and thread scheduling
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
      loop do #in case tag_stream reconnects, we'll connect to new stream
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
      server.mount_proc '/top10' do |_request, response|
        response.body = jsonify(@tag_cache.top10)
      end
    end
  end

  def jsonify(tag_count_pairs)
    JSON.generate({'top10' => tag_count_pairs.map {|t, c| {'tag' => t, 'count' => c}}})
  end
end

