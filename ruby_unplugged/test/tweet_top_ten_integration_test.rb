require 'minitest/autorun'
require 'tweet_top_ten'
require 'open-uri'
require 'json'

class TagStreamSimulator

  def each_tag
    @queue = Queue.new
    yield @queue.pop
  end

  def send(tag)
    @queue << tag
    # Oddly, Thread.pass doesn't get the job done.
    # Empirically, this delay is working on my machine consistently.
    # I dislike tests that rely on sleep, but tolerate them in integration tests.
    sleep 0.003
  end

  def close; end
  def restart; end
end

describe TweetTopTen, "integration" do

  let(:stream_sim) {TagStreamSimulator.new}
  subject {TweetTopTen.new(stream_sim, 8080)}

  before {Thread.new {subject.start}}
  after {subject.quit}

  def top10
    JSON.parse(open('http://localhost:8080/top10').read)['top10']
  end

  it "tells a good story" do
    # Our intrepid system starts out not knowing much
    top10.must_be_empty

    stream_sim.send('my-first-tag')
    stream_sim.send('my-first-tag')
    # Exciting times indeed -- a tag arrives -- twice
    top10.must_equal [{'tag' => 'my-first-tag', 'count' => 2}]

    stream_sim.send('helloworld')
    # A friendly tag too!
    top10.must_equal [{'tag' => 'my-first-tag', 'count' => 2},
                      {'tag' => 'helloworld',   'count' => 1}]

    subject.reset
    # Our first setback, an instant lobotomy
    top10.must_be_empty

    %w(Never gonna give you up
       Never gonna let you down
       Never gonna run around and desert you
       Never gonna make you cry
       Never gonna say goodbye
       Never gonna tell a lie and hurt you).each {|t| stream_sim.send(t)}
    # But we're not out of the game. Tags come rolling in, rickety-split
    top10.must_equal [{'tag' => 'Never', 'count' => 6}, {'tag' => 'gonna',  'count' => 6},
                      {'tag' => 'you',   'count' => 5}, {'tag' => 'and',    'count' => 2},
                      {'tag' => 'a',     'count' => 1}, {'tag' => 'around', 'count' => 1},
                      {'tag' => 'cry',   'count' => 1}, {'tag' => 'desert', 'count' => 1},
                      {'tag' => 'down',  'count' => 1}, {'tag' => 'give',   'count' => 1}]

    stream_sim.send('exit-mic-drop')
    # <insert dramatic applause here>
  end
end
