class StrengthDigit
  include Comparable
  
  BASE = 15
  attr_reader :multiplier, :exponent
  
  def initialize(m, e)
    @multiplier, @exponent = m, e
  end
  
  def strength
    multiplier * BASE**exponent
  end
  
  def <=>(other)
    [exponent, multiplier] <=> [other.exponent, other,multiplier]
  end
  
  def to_s
    "#{multiplier} ^ #{exponent}"
  end
end

class Hand
  include Comparable
  
  RULES = [
    [Proc.new {|fcount, fmax, straight, flush| straight && flush},        12], # straight flush (and royal flush)
    [Proc.new {|fcount, fmax, straight, flush| fcount == 2 && fmax == 4}, 11], # 4 of a kind
    [Proc.new {|fcount, fmax, straight, flush| fcount == 2 && fmax == 3}, 10], # full house
    [Proc.new {|fcount, fmax, straight, flush| flush},                     9], # flush
    [Proc.new {|fcount, fmax, straight, flush| straight},                  8], # straight
    [Proc.new {|fcount, fmax, straight, flush| fcount == 3 && fmax == 3},  7], # 3 of a kind
    [Proc.new {|fcount, fmax, straight, flush| fcount == 3 && fmax == 2},  6], # 2 pair
    [Proc.new {|fcount, fmax, straight, flush| fcount == 4},               5], # pair
    [Proc.new {|fcount, fmax, straight, flush| fcount == 5},               4], # high card
  ]
  
  attr_accessor :stats
  
  def initialize(val)
    @cards = val.split.map {|c| Card.new(c)}.sort
    @stats = create_stats @cards
  end
  
  def create_stats(cards)
    freqs = cards.reduce(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
    
    def freqs.desc_face_map_with_index &block
      self.sort{|a,b| b.reverse <=> a.reverse}.map{|c,f| c}.map.with_index &block
    end
    
    def freqs.max
      self.map {|c, f| f}.max
    end
    
    freqs
  end
  
  def count
    @cards.count
  end
  
  def is_straight?
    @is_straight ||= @cards.each_cons(2).map{|a,b| b.face_value - a.face_value == 1}.all?
  end
  
  def is_flush?
    @is_flush ||= @cards.each_cons(2).map{|a,b| a.suit == b.suit}.all?
  end
  
  def <=>(other)
    strength <=> other.strength
  end
  
  def strengths
    max_exponent = RULES.find{|r| r.first.call(stats.count, stats.max, is_straight?, is_flush?)}.last
    stats.desc_face_map_with_index {|card_value, index| StrengthDigit.new card_value, max_exponent - index}
  end
  
  def strength
    strengths.reduce(0) {|sum, d| sum + d.strength}
  end
  
  def to_s
    "#{@cards.join ' '} str: #{@stats.strength.join ','}"
  end
end
