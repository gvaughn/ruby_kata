require File.dirname(__FILE__) + '/../lib/card.rb'
require File.dirname(__FILE__) + '/../lib/hand.rb'

describe 'hand' do
  it 'knows how many cards it consists of' do
    Hand.new('5H 5C 6S 7S KD').count == 5
  end
  
  [["pair of 3s beat a pair of 2s",         '3A 3B 5C 7D 9E',   '2A 2B 5C 7D AE'],
   ["4 of a kind should beat 3 of a kind",  '2H 2C 2D 2S JC',   '5H 5C 8S 9S 2D'],
   ["pair should beat high card",           '8H 5C 5S 9S 2D',   '2H 4C 6S 8D TH'],
   ["3 of a kind should beat pair",         '4H 4C 4D 2H JC',   '5H 5C 8S 9S 2D'],
   ["4 of a kind should beat pair",         '4H 4C 4D 4S JC',   '5H 5C 8S 9S 2D'],
   ["A high beats K high",                  "AA 2B 4C 6D 8E",   "KA 2B 4C 6D 8E"],
   ["pairs use kicker for tie",             "8H 8S AC 2S 3D",   "8C 8D KD 9S 2C"],
   ["two pair 2s and 3s beats pair of As",  "2H 2S 3C 3S 4D",   "AC AD JD TS QC"],
   ["full house beats 3 of a kind",         "2H 2S 3C 3S 3D",   "AC AD AD TS QC"],
    ].each do |desc, winner, loser|
      it desc do
        Hand.new(winner).should > Hand.new(loser)
      end
    end
end

describe 'hand strengths' do
  
  def high_exponent(cards)
    Hand.new(cards).strengths.first.last
  end
  
  [['creates maximum strength of 4 for high card hand',      '2H 4C 6S 8D TH', 4],
   ['creates maximum strength of 5 for pair hand',           '2A 2B 5C 7D AE', 5],
   ['creates maximum strength of 6 for 2 pair hand',         "2H 2S 3C 3S 4D", 6],
   ['creates maximum strength of 7 for 3 of a kind hand',    '4H 4C 4D 2H JC', 7],
   ['creates maximum strength of 8 for straight hand',       '4H 5C 6D 7S 8C', 8],
   ['creates maximum strength of 9 for flush hand',          '4H 5H 6H TH 8H', 9],
   ['creates maximum strength of 10 for full house hand',    '4H 4C 4D 3S 3C', 10],
   ['creates maximum strength of 11 for 4 of a kind hand',    '4H 4C 4D 4S JC', 11],
   ['creates maximum strength of 12 for straight flush hand', 'TH 9H 8H 7H 6H', 12],
  ].each do |desc, cards, expected|
    it desc do
      high_exponent(cards).should be expected
    end
  end
  
end