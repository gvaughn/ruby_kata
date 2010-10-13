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
    13 * (max_freq <=> other.max_freq) + 
    (strength_card <=> other.strength_card)
  end
  
  def max_freq
    @freq_map.map{|m| m[1]}.max
  end
  
  def strength_card
    @freq_map.max {|a,b| a.reverse <=> b.reverse }
  end
  
  def to_s
    @cards.join ' '
  end
end
