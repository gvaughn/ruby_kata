class StrengthDigit
  BASE = 15
  attr_reader :multiplier, :exponent
  
  def initialize(m, e)
    @multiplier, @exponent = m, e
  end
  
  def strength
    multiplier * BASE**exponent
  end
end

class Hand
  include Comparable
  
  def initialize(val)
    @cards = val.split.map {|c| Card.new(c)}

    @freq_map = @cards.inject(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
    
    @strengths = @freq_map.select {|face, freq| freq > 1}.map {|face, freq| StrengthDigit.new(face, freq + 3)}
    @freq_map.select {|face, freq| freq == 1}.sort.each_with_index {|pair, i| @strengths << StrengthDigit.new(pair.first, i)}
  end
  
  def count
    @cards.count
  end
  
  def <=>(other)
    strength <=> other.strength
  end
  
  def strength
    @strengths.reduce(0) {|sum, s| sum += s.strength}
  end

  def to_s
    @cards.join ' '
  end
end
