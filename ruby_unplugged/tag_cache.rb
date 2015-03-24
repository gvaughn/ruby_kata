class TagCache
  #TODO thread safety
  # background thread to truncate raw_array before it gets too large

  def initialize(initial_array = [])
    # @raw array consists of 2 element pairs [timestamp, tag]
    # new elements must be shifted to the front so timestamp is
    # descending when moving along array
    @raw_array = initial_array
  end

  def put(tag)
    @raw_array.unshift([Time.now.to_i, tag])
  end

  # returns a 10 element array consisting of 2 element pairs [tag, count]
  # sorted in descending count order, and secondarily by tag's alphabetical order
  def top10
    sixty_seconds_ago = Time.now.to_i - 60

    @raw_array.take_while {|(timestamp, _tag)|
      timestamp > sixty_seconds_ago                         # grab raw data we care about
    }.each_with_object(Hash.new(0)) {|(_ts, tag), freq_hash|
      freq_hash[tag] += 1                                   #create hash of tag => count of times used
    }.sort_by {|(tag, freq)|
      [-freq, tag]                                          #sort by count descending and tag alpha
    }.take(10)
  end
end

