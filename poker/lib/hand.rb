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
  
  def map_pair_like(&block)
    @freqs.select {|face, freq| freq > 1}.map &block
  end
  
  def map_sorted_kickers
    n = -1
    @freqs.select {|face, freq| freq == 1}.sort.map {|face, freq| n += 1; yield face, n}
  end
  
  def strength
    # when @freqs.count == 5
    n = -1
    @freqs.sort.map {|pair| n +=1; StrengthDigit.new pair.first, n}
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
