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
  
  def max_freq
    @max_freq ||= @freqs.collect {|c, f| f}.max
  end
  
  def is_straight
    @is_straight ||= @freqs.value_by_desc_freq.each_cons(2).map{|a,b| a - b}.all? {|a| a == 1}
  end
  
  def is_flush
    @is_flush ||= @cards.each_cons(2).map{|a,b| a.suit == b.suit}.all?
  end
  
  def strength_digits(max_exponent)
    @freqs.value_by_desc_freq.map.with_index {|c,n| StrengthDigit.new c, max_exponent - n}
  end
  
  def strength
    return strength_digits(4)  if @freqs.count == 5 && !is_straight && !is_flush #high card
    return strength_digits(5)  if @freqs.count == 4 #pair
    return strength_digits(6)  if @freqs.count == 3 && max_freq == 2 #2 pair
    return strength_digits(7)  if @freqs.count == 3 && max_freq == 3 #3 of a kind
    return strength_digits(8)  if @freqs.count == 5 && is_straight && !is_flush #straight
    return strength_digits(9)  if @freqs.count == 5 && is_flush #flush
    return strength_digits(10)  if @freqs.count == 2 && max_freq == 3 #full house
    return strength_digits(11)  if @freqs.count == 2 && max_freq == 4 #4 of a kind
    #straight flush (royal is covered)
  end
  
end

class Hand
  include Comparable
  
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
  
  def strength
    @stats.strength.reduce(0) {|sum, s| sum + s.strength}
  end

  def to_s
    "#{@cards.join ' '} str: #{@stats.strength.join ','}"
  end
end
