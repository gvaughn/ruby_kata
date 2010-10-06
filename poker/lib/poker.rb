class Card
  include Comparable
  attr_accessor :face_value
  
  MAP =
  {
    'A' => 14,
    'K' => 13,
  }

  #hello
  def initialize(val)
    @face_value = val
    @face_value = MAP[val] if MAP.has_key? val
  end
  
  def <=>(other)
    face_value <=> other.face_value
  end
end
