require File.dirname(__FILE__) + '/../lib/poker.rb'

describe 'poker' do
  describe 'card comparison' do
    [
      ['A','K'],
      ['K','Q'],
      ['Q','J'],
      ['J','T'],
      ['T','9'],
      ['9','8'],
      ['8','7'],
      ['7','6'],
      ['6','5'],
      ['5','4'],
      ['4','3'],
      ['3','2'],
    ].each do |first, second|
      it "#{first} should beat #{second}" do
        Card.new(first).should > Card.new(second)
      end
    end
  
    it "accepts suit" do
      Card.new('KH').suit == Card.new('5H').suit
    end
  end
  
  describe 'hand' do
    it 'knows how many cards it consists of' do
      Hand.new('5H 5C 6S 7S KD').count == 5
    end
    
    [["pair of 3s beat a pair of 2s",         '3A 3B 5C 7D 9E',   '2A 2B 5C 7D AE'],
     ["4 of a kind should beat 3 of a kind",  '2H 2C 2D 2S JC',   '5H 5C 8S 9S 2D'],
     ["pair should beat high card",           '8H 5C 5S 9S 2D',   '2H 4C 6S 8D 10H'],
     ["3 of a kind should beat pair",         '4H 4C 4D 2H JC',   '5H 5C 8S 9S 2D'],
     ["4 of a kind should beat pair",         '4H 4C 4D 4S JC',   '5H 5C 8S 9S 2D'],
     ["A high beats K high",                  "AA 2B 4C 6D 8E",   "KA 2B 4C 6D 8E"]
      ].each do |desc, winner, loser|
        it desc do
          Hand.new(winner).should > Hand.new(loser)
        end
      end
  end
end
