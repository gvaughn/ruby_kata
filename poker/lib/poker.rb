class Card
  include Comparable
  attr_reader :face_value
  
  MAP =
  {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    'T' => 10,
  }

  def initialize(val)
    @face_value = val.to_i
    @face_value = MAP[val] if MAP.has_key? val
  end
  
  def <=>(other)
    face_value <=> other.face_value
  end
end
