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

class FrequencyStats
  def initialize(cards)
    @cards = cards
    @freqs = cards.reduce(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
    def @freqs.value_by_desc_freq
      self.sort{|a,b| b.reverse <=> a.reverse}.map{|c,f| c}
    end
  end
  
  def freq_count
    @freqs.count
  end
  
  def max_freq
    @max_freq ||= @freqs.collect {|c, f| f}.max
  end
  
  def is_straight
    @is_straight ||= @freqs.value_by_desc_freq.each_cons(2).map{|a,b| a - b == 1}.all?
  end
  
  def is_flush
    @is_flush ||= @cards.each_cons(2).map{|a,b| a.suit == b.suit}.all?
  end
  
  def strength_digits(max_exponent)
    @freqs.value_by_desc_freq.map.with_index {|c,n| StrengthDigit.new c, max_exponent - n}
  end
  
end

class Hand
  include Comparable
  
  MAX_EXPONENT = 12
  RULES = [
    [Proc.new {|fcount, fmax, straight, flush| straight && flush}, 12], # straight flush
    [Proc.new {|fcount, fmax, straight, flush| fcount == 2 && fmax == 4}, 11], # 4 of a kind
    [Proc.new {|fcount, fmax, straight, flush| fcount == 2 && fmax == 3}, 10], # full house
    [Proc.new {|fcount, fmax, straight, flush| flush}, 9], # flush
    [Proc.new {|fcount, fmax, straight, flush| straight}, 8], # straight
    [Proc.new {|fcount, fmax, straight, flush| fcount == 3 && fmax == 3}, 7], # 3 of a kind
    [Proc.new {|fcount, fmax, straight, flush| fcount == 3 && fmax == 2}, 6], # 2 pair
    [Proc.new {|fcount, fmax, straight, flush| fcount == 4}, 5], # pair
    [Proc.new {|fcount, fmax, straight, flush| fcount == 5}, 4], # high card
  ]
  
  attr_accessor :stats
  def initialize(val)
    @cards = val.split.map {|c| Card.new(c)}
    @stats = FrequencyStats.new @cards
  end
  
  def count
    @cards.count
  end
  
  def <=>(other)
    strength <=> other.strength
  end
  
  def strengths
    stats.strength_digits RULES.find{|r| r.first.call(stats.freq_count, stats.max_freq, stats.is_straight, stats.is_flush)}.last
  end
  
  def strength
    strengths.reduce(0) {|sum, d| sum + d.strength}
  end
  
  def to_s
    "#{@cards.join ' '} str: #{@stats.strength.join ','}"
  end
end
