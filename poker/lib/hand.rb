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
    [proc {|fcount, fmax, straight, flush| straight && flush},         9], # straight flush (and royal flush)
    [proc {|fcount, fmax, straight, flush| fcount == 2 && fmax == 4},  8], # 4 of a kind
    [proc {|fcount, fmax, straight, flush| fcount == 2 && fmax == 3},  7], # full house
    [proc {|fcount, fmax, straight, flush| flush},                     6], # flush
    [proc {|fcount, fmax, straight, flush| straight},                  5], # straight
    [proc {|fcount, fmax, straight, flush| fcount == 3 && fmax == 3},  4], # 3 of a kind
    [proc {|fcount, fmax, straight, flush| fcount == 3 && fmax == 2},  3], # 2 pair
    [proc {|fcount, fmax, straight, flush| fcount == 4},               2], # pair
    [proc {|fcount, fmax, straight, flush| fcount == 5},               1], # high card
  ]
  
  def initialize(str)
    @cards = str.split.map {|val| [FACE_MAP[val[0,1]], val[-1,1]]}.sort.reverse
    @stats = @cards.reduce(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
  end
  
  def count
    @cards.count
  end
  
  def power_cards
    @stats.sort{|a,b| b.reverse <=> a.reverse}.map(&:face_value)
  end
  
  def rank
    characteristics = [
      @stats.count, 
      @stats.map(&:frequency).max, 
      @cards.each_cons(2).all?{|a,b| a.face_value - b.face_value == 1}, 
      @cards.each_cons(2).all?{|a,b| a.suit == b.suit}
    ]
    RULES.find{|r| r.first.call(characteristics)}.last
  end
  
  def <=>(other)
    ( [rank] << power_cards) <=> ( [other.rank] << other.power_cards)
  end
  
  def to_s
    "#{@cards.join ' '} str: #{strength.join ','}"
  end
end
