require 'tag_cache'

describe TagCache do
  describe "#top10" do
    it "returns list of 10 tag/count pairs from last 60 seconds" do
      now = Time.now.to_i
      sample_data = (0..65).step(5).map {|offset|
        [now - offset, "tag#{offset}"]
      }
      sample_data.insert(1, [now - 2, "tag55"])
      # This extra forces the oldest tag to be counted in the top 10
      # since it's more frequent
      tc = TagCache.new(sample_data)
      top10 = tc.top10

      top10.count.must_equal 10
      top10.first.must_equal ["tag55", 2]
      top10.last.must_equal ["tag45", 1] #secondary sort by tag makes this last
    end
  end
end

