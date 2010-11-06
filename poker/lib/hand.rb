class Hand
  include Comparable
  
  class ::Array
    alias :face_value :first
    alias :suit :last
  end

  class Characteristics
    def initialize(cards)
      @fcards = cards.reduce(Hash.new(0)) {|h, c| h[c.face_value] += 1; h}.sort{|a,b| b.reverse <=> a.reverse}
      @fsuits = cards.reduce(Hash.new(0)) {|h, c| h[c.suit] += 1; h}
      @gaps = cards.each_cons(2).map {|a, b| a.face_value - b.face_value}
    end
    
    def num_freq
      @fcards.count
    end
    
    def max_freq
      @fcards.first.last
    end
    
    def straight?
      @gaps.all? {|g| g == 1}
    end
    
    def flush?
      @fsuits.count == 1
    end
    
    def power_cards
      @fcards.map(&:face_value)
    end
  end
  
  class Type
    attr_reader :name, :rank
    def initialize(name, rank, &matcher)
      @name, @rank, @matcher = name, rank, matcher
    end
    
    def match(chx)
      @matcher[chx]
    end
    
    def power_cards(chx)
      @chx.power_cards
    end
  end
  
  FACE_CARDS = {'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10}
  FACE_MAP = Hash.new {|h,k| k.to_i}
  FACE_MAP.merge! FACE_CARDS

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
  
  def initialize(str)
    @cards = str.split.map {|val| [FACE_MAP[val[0,1]], val[-1,1]]}.sort.reverse
    @chx = Characteristics.new(@cards)
  end
  
  def count
    @cards.count
  end
  
  def power_cards #smelly, refactor later
    @chx.power_cards
  end
  
  def rank
    RULES.find{|r| r.match(@chx)}.rank
  end
  
  def <=>(other)
    ( [rank] << power_cards) <=> ( [other.rank] << other.power_cards)
  end
  
  def to_s
    "#{@cards.join ' '} str: #{strength.join ','}"
  end
end
