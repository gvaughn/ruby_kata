class Card
  include Comparable
  attr_reader :face_string, :face_value, :suit
  
  FACE_CARDS = {'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10}
  FACE_MAP = Hash.new {|h,k| k.to_i}
  FACE_MAP.merge! FACE_CARDS

  def initialize(val)
    @face_string = val[0,1]
    @face_value = FACE_MAP[@face_string]
    @suit = val[-1,1]
  end
  
  def <=>(other)
    face_value <=> other.face_value
  end
  
  def to_s
    "#{face_string}#{suit}"
  end
end

