class Card
  include Comparable
  
  FACE_CARDS = {'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10}
  FACE_MAP = Hash.new {|h,k| k.to_i}
  FACE_MAP.merge! FACE_CARDS

  attr_reader :face_value, :suit
  
  def initialize(face, suit)
    @face_str = face
    @face_value = FACE_MAP[face]
    @suit = suit
  end
  
  def gap(other)
    face_value - other.face_value
  end
  
  def <=>(other)
    face_value <=> other.face_value
  end
  
  def to_s
    "#{@face_str}#{suit}"
  end
end

class Type
  include Comparable

  attr_reader :name, :rank

  def initialize(name, rank, &matcher)
    @name, @rank, @matcher = name, rank, matcher
  end
  
  def match(chx)
    @matcher[chx]
  end
  
  def <=>(other)
    rank <=> other.rank
  end
  
  def self.for(chx)
    RULES.find{|r| r.match(chx)}
  end

  RULES = [
    Type.new('straight flush', 9) {|c| c.straight? && c.flush?},
    Type.new('quads', 8)          {|c| c.num_freq == 2 && c.max_freq == 4},
    Type.new('full house', 7)     {|c| c.num_freq == 2 && c.max_freq == 3},
    Type.new('flush', 6)          {|c| c.flush?},
    Type.new('straight', 5)       {|c| c.straight?},
    Type.new('trips', 4)          {|c| c.num_freq == 3 && c.max_freq == 3}, 
    Type.new('2 pair', 3)         {|c| c.num_freq == 3 && c.max_freq == 2},
    Type.new('pair', 2)           {|c| c.num_freq == 4},
    Type.new('high card', 1)      {|c| c.num_freq == 5},
  ]
end

class Characteristics
  def initialize(cards)
    @fcards = cards.reduce(Hash.new(0)) {|h, c| h[c.face_value] += 1; h}.sort{|a,b| b.reverse <=> a.reverse}
    @fsuits = cards.reduce(Hash.new(0)) {|h, c| h[c.suit] += 1; h}
    @gaps = cards.each_cons(2).map {|a, b| a.gap(b)}
  end
  
  def num_freq
    @fcards.count
  end
  
  def max_freq
    @fcards.first.last
  end
  
  def straight?
    if @gaps == [9,1,1,1] # ace-low straight
      @fcards.shift #get rid of ace-high tiebreaker
      return true
    end
    @gaps.all? {|g| g == 1}
  end
  
  def flush?
    @fsuits.count == 1
  end
  
  def tie_breakers
    @fcards.map(&:first) #it's the face_value
  end
end

class Hand
  include Comparable
  
  def initialize(str)
    @cards = str.split.map {|val| Card.new(val[0,1], val[-1,1])}.sort.reverse
    @chx = Characteristics.new(@cards)
  end
  
  def count
    @cards.count
  end
  
  def tie_breakers
    @chx.tie_breakers
  end
  
  def type
    @type ||= Type.for(@chx)
  end
  
  def <=>(other)
    ( [type] << tie_breakers) <=> ( [other.type] << other.tie_breakers)
  end
  
  def to_s
    "#{type.name}: #{@cards.join ' '}"
  end
end
