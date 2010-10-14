class Hand
  include Comparable
  
  def initialize(val)
    @cards = val.split.map {|c| Card.new(c)}

    @freq_map = @cards.inject(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
  end
  
  def count
    @cards.count
  end
  
  def <=>(other)
    strength <=> other.strength
  end

  def strength
    pair_like = @freq_map.select {|face, freq| freq > 1}.to_a
    kickers = @freq_map.select {|face, freq| freq == 1}.map {|face, freq| face}.sort

    strength = pair_like.reduce(0) {|sum, pair| sum += 15**(pair.last + 3) * pair.first}
    kickers.each_with_index {|face, i| strength += 15**i * face}
    strength
  end

  def max_freq
    @freq_map.map{|m| m[1]}.max
  end
  
  def to_s
    @cards.join ' '
  end
end
