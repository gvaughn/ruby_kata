class StrengthDigit
  include Comparable
  
  BASE = 15
  attr_reader :multiplier, :exponent
  
  def initialize(m, e)
    @multiplier, @exponent = m, e
  end
  
  def strength
    multiplier * BASE**exponent
  end
  
  def <=>(other)
    [exponent, multiplier] <=> [other.exponent, other,multiplier]
  end
end

class FrequencyStats
  def initialize(cards)
    @freqs = cards.reduce(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
  end
  
  def max_freq
    @max_freq ||= @freqs.collect {|c, f| f}.max
  end
  
  def map_pair_like(&block)
    @freqs.select {|face, freq| freq > 1}.map &block
  end
  
  def map_sorted_kickers
    n = -1
    @freqs.select {|face, freq| freq == 1}.sort.map {|face, freq| n += 1; yield face, n}
  end
  
  def sorted_progression(offset) #lousy name, getting tired
    n = -1
    @freqs.sort.map {|pair| n +=1; StrengthDigit.new pair.first, n + offset}
  end
  
  def strength
    return sorted_progression(0)  if @freqs.count == 5  #high card
    return sorted_progression(2)  if @freqs.count == 4 #pair
    return sorted_progression(4)  if @freqs.count == 3 && max_freq == 2 #2 pair
    return sorted_progression(5)  if @freqs.count == 3 && max_freq == 3 #3 of a kind
  end
  
end

class Hand
  include Comparable
  
  def initialize(val)
    @cards = val.split.map {|c| Card.new(c)}
    
    stats = FrequencyStats.new @cards
    @strengths = stats.map_pair_like {|face,freq| StrengthDigit.new(face, freq+3)}
    @strengths += stats.map_sorted_kickers {|face, sort_index| StrengthDigit.new(face, sort_index)}
  end
  
  def count
    @cards.count
  end
  
  def <=>(other)
    strength <=> other.strength
  end
  
  def strength
    @strengths.reduce(0) {|sum, s| sum + s.strength}
  end

  def to_s
    @cards.join ' '
  end
end
