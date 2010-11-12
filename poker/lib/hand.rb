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
  
  def match(hand)
    @matcher[hand]
  end
  
  def strength(fcards)
    [self] << fcards.map(&:first) #it's the face_value
  end
  
  def <=>(other)
    rank <=> other.rank
  end
  
  def self.straight?(gaps, fcards)
    if gaps == [9,1,1,1] # ace-low straight
      fcards.shift #get rid of ace-high tiebreaker
      return true
    end
    gaps.all? {|g| g == 1}
  end
  
  def self.for(cards)
    stats = self.stats_for(cards)
    RULES.find{|r| r.match(stats)}.strength(stats.first)
  end
  
  def self.stats_for(cards)
    fcards = cards.reduce(Hash.new(0)) {|h, c| h[c.face_value] += 1; h}.sort{|a,b| b.reverse <=> a.reverse}
    fsuits = cards.reduce(Hash.new(0)) {|h, c| h[c.suit] += 1; h}
    gaps = cards.each_cons(2).map {|a, b| a.gap(b)}
    [fcards, gaps, fsuits.count, fcards.count, fcards.first.last]
  end

  RULES = [
    Type.new('straight flush', 9) {|fcards, gaps, nsuits, nfreq, mfreq| Type.straight?(gaps, fcards) && nsuits == 1},
    Type.new('quads', 8)          {|fcards, gaps, nsuits, nfreq, mfreq| nfreq == 2 && mfreq == 4},
    Type.new('full house', 7)     {|fcards, gaps, nsuits, nfreq, mfreq| nfreq == 2 && mfreq == 3},
    Type.new('flush', 6)          {|fcards, gaps, nsuits, nfreq, mfreq| nsuits == 1},
    Type.new('straight', 5)       {|fcards, gaps, nsuits, nfreq, mfreq| Type.straight?(gaps, fcards)},
    Type.new('trips', 4)          {|fcards, gaps, nsuits, nfreq, mfreq| nfreq == 3 && mfreq == 3}, 
    Type.new('2 pair', 3)         {|fcards, gaps, nsuits, nfreq, mfreq| nfreq == 3 && mfreq == 2},
    Type.new('pair', 2)           {|fcards, gaps, nsuits, nfreq, mfreq| nfreq == 4},
    Type.new('high card', 1)      {|fcards, gaps, nsuits, nfreq, mfreq| nfreq == 5},
  ]
end

class Hand
  include Comparable
  
  def initialize(str)
    @cards = str.split.map {|val| Card.new(val[0,1], val[-1,1])}.sort.reverse
  end
  
  def count
    @cards.count
  end
  
  def strength
    @strength ||= Type.for(@cards)
  end
  
  def type
    strength.first
  end
  
  def <=>(other)
    strength <=> other.strength
  end
  
  def to_s
    "#{type.name}: #{@cards.join ' '}"
  end
end
