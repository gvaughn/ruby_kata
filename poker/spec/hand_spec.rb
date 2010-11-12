require File.dirname(__FILE__) + '/../lib/hand.rb'

describe 'hand' do
  HANDS = [
    ['straight flush',  'TH 9H 8H 7H 6H'],
    ['quads',           '4H 4C 4D 4S JC'],
    ['full house',      '4H 4C 4D 3S 3C'],
    ['flush',           '4H 5H 6H TH 8H'],
    ['straight',        '4H 5C 6D 7S 8C'],
    ['trips',           '4H 4C 4D 2H JC'],
    ['2 pair',          "2H 2S 3C 3S 4D"],
    ['pair',            '2A 2B 5C 7D AE'],
    ['high card',       '2H 4C 6S 8D TH'],
  ]
  
  it 'knows how many cards it consists of' do
    Hand.new('5H 5C 6S 7S KD').count == 5
  end

  MAX_RANK = 9
  describe 'rank' do
    HANDS.each.with_index do |hand, index|
      desc, cards = hand
      expected = MAX_RANK - index
      it "#{desc} is rank #{expected}" do
        Hand.new(cards).type.rank.should be expected
      end
    end
    
    it 'recognizes Ace-low straight' do
      Hand.new('AH 2C 3D 4H 5S').type.rank.should == 5
    end
  end

  describe 'comparisons' do
    while winner = HANDS.shift
      HANDS.each.with_object(winner) do |loser, winner|
        it "#{winner.first} beats #{loser.first}" do
          Hand.new(winner.last).should > Hand.new(loser.last)
        end
      end
    end

    describe 'with tiebreakers' do
      [["pair of 3s beat a pair of 2s",  '3A 3B 5C 7D 9E',   '2A 2B 5C 7D AE'],
       ["A high beats K high",           'AA 2B 4C 6D 8E',   'KA 2B 4C 6D 8E'],
       ["pairs use kicker for tie",      '8H 8S AC 2S 3D',   '8C 8D KD 9S 2C'],
      ].each do |desc, winner, loser|
        it desc do
          Hand.new(winner).should > Hand.new(loser)
        end
      end
    end
  end
end
