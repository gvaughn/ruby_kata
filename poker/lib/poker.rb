class Card
  include Comparable
  attr_reader :face_value, :suit
  
  MAP =
  {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    'T' => 10,
  }

  def initialize(val)
    get_face val[0]
    
    @suit = val[1]
  end
  
  def get_face(f)
    @face_value = f.to_i

    @face_value = MAP[f] if MAP.has_key? f 
  end

  def <=>(other)
    face_value <=> other.face_value
  end
end
