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
    @freqs = cards.reduce(Hash.new(0)) {|m, c| m[c.face_value] += 1; m}
    def @freqs.value_by_desc_freq
      self.sort{|a,b| b.reverse <=> a.reverse}.map{|c,f| c}
    end
  end
  
  def max_freq
    @max_freq ||= @freqs.collect {|c, f| f}.max
  end
  
  def strength_digits(offset)
    max_exponent = offset + @freqs.count - 1
    @freqs.value_by_desc_freq.map.with_index {|c,n| StrengthDigit.new c, max_exponent - n}
  end
  
  def strength
    return strength_digits(0)  if @freqs.count == 5  #high card
    return strength_digits(2)  if @freqs.count == 4 #pair
    return strength_digits(4)  if @freqs.count == 3 && max_freq == 2 #2 pair
    return strength_digits(5)  if @freqs.count == 3 && max_freq == 3 #3 of a kind
    #straight
    #flush
    #full house
    return strength_digits(10)  if @freqs.count == 2 && max_freq == 4 #4 of a kind
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
