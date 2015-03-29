class TagCache

  # data is an initial dataset. TODO validate format (but only used for tests thus far)
  # truncate_interval is time (in seconds) to throw away old data
  def initialize(data: [], truncate_interval: 300)
    # @raw array consists of 2 element pairs [timestamp, tag]
    # new elements must be shifted to the front so timestamp is
    # descending when moving along array
    @raw_array = data
    @semaphore = Mutex.new

    # Lets keep @raw_array from growing without bound
    # We could do this with each #put, but I'd expect better throughput
    # from this instead
    Thread.new {
      begin
        while(true)
          sleep truncate_interval
          truncate_old_data
        end
      rescue
        retry
      end
    }
  end

  def put(tag)
    @semaphore.synchronize {
      @raw_array.unshift([Time.now.to_i, tag])
    }
    tag
  end
  alias :<< :put

  # empties the list of seen tags
  # note: this is not a synchronized operation
  # because that cannot be called in a signal trap handler
  def reset
    puts "resetting tag cache statistics"
    @raw_array = []
  end

  # returns a 10 element array consisting of 2 element pairs [tag, count]
  # sorted in descending count order, and secondarily by tag's alphabetical order
  def top10
    sixty_second_snapshot.each_with_object(Hash.new(0)) {|(_ts, tag), freq_hash|
      freq_hash[tag] += 1         #create hash of tag => count of times used
    }.sort_by {|(tag, freq)|
      [-freq, tag]                #sort by count descending and tag alpha
    }.take(10)
  end

  private

  def truncate_old_data
    @semaphore.synchronize {
      @raw_array = @raw_array.take_while(&timestamp_newer_than(sixty_seconds_ago))
    }
  end

  def sixty_second_snapshot
    @semaphore.synchronize {
      @raw_array.take_while(&timestamp_newer_than(sixty_seconds_ago))
    }
  end

  def timestamp_newer_than(threshold)
    proc {|(timestamp, _tag)| timestamp > threshold}
  end

  def sixty_seconds_ago
    Time.now.to_i - 60
  end
end

