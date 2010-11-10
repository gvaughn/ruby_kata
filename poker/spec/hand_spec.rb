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
  
  [['high card hand',       '2H 4C 6S 8D TH', 1],
   ['pair hand',            '2A 2B 5C 7D AE', 2],
   ['2 pair hand',          "2H 2S 3C 3S 4D", 3],
   ['3 of a kind hand',     '4H 4C 4D 2H JC', 4],
   ['straight hand',        '4H 5C 6D 7S 8C', 5],
   ['flush hand',           '4H 5H 6H TH 8H', 6],
   ['full house hand',     '4H 4C 4D 3S 3C', 7],
   ['4 of a kind hand',    '4H 4C 4D 4S JC', 8],
   ['straight flush hand', 'TH 9H 8H 7H 6H', 9],
  ].each do |desc, cards, expected|
    it "#{desc} is rank #{expected}" do
      Hand.new(cards).type.rank.should be expected
    end
  end
  
end