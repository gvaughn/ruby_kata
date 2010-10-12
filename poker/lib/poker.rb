class Card
  include Comparable
  attr_reader :face_value, :suit
  
  FACE_CARDS = {'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10}
  FACE_MAP = Hash.new {|h,k| k.to_i}
  FACE_MAP.merge! FACE_CARDS

  def initialize(val)
    @face_value = FACE_MAP[val[0,1]]
    @suit = val[-1,1]
  end
  
  def <=>(other)
    face_value <=> other.face_value
  end
end

class Hand
  include Comparable
  def initialize(val)
    @cards = val.split.map {|c| Card.new(c)}
  end
  
  def count
    @cards.count
  end
  
  def <=>(other)
    13 * (max_freq <=> other.max_freq) + 
    (strength_card <=> other.strength_card)
  end
  
  def max_freq
    freq_map.map{|m| m[1]}.max
  end
  
  def freq_map
    @cards.inject(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
  end
  
  def strength_card
    freq_map.sort_by{|a| [-a[1],-a[0]]}.first[0]
  end
end
