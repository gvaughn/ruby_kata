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
  end
  
  def max_freq
    @max_freq ||= @freqs.collect {|c, f| f}.max
  end
  
  def sorted_progression(offset) #lousy name, getting tired
    n = -1
    @freqs.sort{|a,b| a.reverse <=> b.reverse}.map {|pair| n +=1; StrengthDigit.new pair.first, n + offset}
  end
  
  def strength
    return sorted_progression(0)  if @freqs.count == 5  #high card
    return sorted_progression(2)  if @freqs.count == 4 #pair
    return sorted_progression(4)  if @freqs.count == 3 && max_freq == 2 #2 pair
    return sorted_progression(5)  if @freqs.count == 3 && max_freq == 3 #3 of a kind
    #straight
    #flush
    #full house
    return sorted_progression(10)  if @freqs.count == 2 && max_freq == 4 #4 of a kind
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
    "#{@cards.join ' '} str: #{@stats.strength.reverse.join ','}"
  end
end
