class Card
  include Comparable
  attr_reader :face_value, :suit
  
  FACE_CARDS = {'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10}
  FACE_MAP = Hash.new {|h,k| k.to_i}
  FACE_MAP.merge! FACE_CARDS

  def initialize(val)
    @face_value = FACE_MAP[val[0..1]]
    @suit = val[-1..1]
  end
  
  def <=>(other)
    face_value <=> other.face_value
  end
end

class Hand
  def initialize(val)
    @cards = val.split.map {|c| Card.new(c)}
  end
  
  def count
    @cards.count
  end
end