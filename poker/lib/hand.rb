class Array
  alias :face_value :first
  alias :frequency :last
  alias :suit :last
end

class Hand
  include Comparable
  
  FACE_CARDS = {'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10}
  FACE_MAP = Hash.new {|h,k| k.to_i}
  FACE_MAP.merge! FACE_CARDS

  RULES = [
    [proc {|fcount, fmax, straight, flush| straight && flush},        12], # straight flush (and royal flush)
    [proc {|fcount, fmax, straight, flush| fcount == 2 && fmax == 4}, 11], # 4 of a kind
    [proc {|fcount, fmax, straight, flush| fcount == 2 && fmax == 3}, 10], # full house
    [proc {|fcount, fmax, straight, flush| flush},                     9], # flush
    [proc {|fcount, fmax, straight, flush| straight},                  8], # straight
    [proc {|fcount, fmax, straight, flush| fcount == 3 && fmax == 3},  7], # 3 of a kind
    [proc {|fcount, fmax, straight, flush| fcount == 3 && fmax == 2},  6], # 2 pair
    [proc {|fcount, fmax, straight, flush| fcount == 4},               5], # pair
    [proc {|fcount, fmax, straight, flush| fcount == 5},               4], # high card
  ]
  
  def initialize(str)
    create_cards str
    create_stats
  end
  
  def create_cards(str)
    @cards = str.split.map {|val| [FACE_MAP[val[0,1]], val[-1,1]]}.sort.reverse
    
    def @cards.pairwise? &block
      each_cons(2).all? &block
    end
  end
  
  def create_stats
    @stats = @cards.reduce(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
    
    def @stats.desc_face_values
      sort{|a,b| b.reverse <=> a.reverse}.map(&:face_value)
    end
  end
  
  def count
    @cards.count
  end
  
  def rank
    characteristics = [
      @stats.count, 
      @stats.map(&:frequency).max, 
      @cards.pairwise?{|a,b| a.face_value - b.face_value == 1}, 
      @cards.pairwise?{|a,b| a.suit == b.suit}
    ]
    RULES.find{|r| r.first.call(characteristics)}.last
  end
  
  def <=>(other)
    strength <=> other.strength
  end
  
  def strength
    [rank] << @stats.desc_face_values
  end
  
  def to_s
    "#{@cards.join ' '} str: #{strength.join ','}"
  end
end
