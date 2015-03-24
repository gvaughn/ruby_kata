require 'tag_cache'

describe TagCache do
  describe "#top10" do
    it "returns list of 10 tag/count pairs from last 60 seconds" do
      now = Time.now.to_i
      sample_data = (0..65).step(5).map {|offset|
        [now - offset, "tag#{offset}"]
      }
      # This extra forces the oldest tag to be counted in the top 10
      # since it's more frequent
      sample_data.insert(1, [now - 2, "tag55"])

      tc = TagCache.new(data: sample_data)
      3.times {tc.put("extratag")}
      top10 = tc.top10

      top10.count.must_equal 10
      top10.first.must_equal ["extratag", 3]
      top10[1].must_equal ["tag55", 2]
      top10.last.must_equal ["tag40", 1] #secondary sort by tag makes this last
    end

    it "handles multiple threads" do
      tc = TagCache.new(truncate_interval: 0.1)
      result = []

      t1 = Thread.new {
        10.times {|n| tc.put("t#{n}-from1"); sleep 0.2}
      }

      t2 = Thread.new {
        sleep 0.1
        12.times {|n| tc.put("t#{n}-from2"); sleep 0.15}
      }

      t3 = Thread.new {
        sleep 1.9
        result = tc.top10
      }

      t1.join
      t2.join
      t3.join

      #puts result.inspect
      # basically this is an assert_nothing_raised which minitest doesn't have (for good reasons)
      # It's a difficult test to automate in general
    end
  end
end

