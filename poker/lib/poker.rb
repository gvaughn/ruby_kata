class Card
  include Comparable
  attr_reader :face_value
  attr_reader :suit
  
  MAP =
  {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    'T' => 10,
  }

  def get_face(f)
    @face_value = f.to_i

    @face_value = MAP[f] if MAP.has_key? f 
  end

  def initialize(val)
    get_face val.to_s.take(1).to_s

    suit = val[1] if val.to_s.length > 1
  end
  
  def <=>(other)
    face_value <=> other.face_value
  end
end
