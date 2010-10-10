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
    it 'knowns how many cards it consists of' do
      Hand.new('5H 5C 6S 7S KD').count == 5
    end
    
    it "pair should beat nothing" do
      Hand.new('5H 5C 8S 9S 2D').should > Hand.new('2H 4C 6S 8D 10H')
    end
  end
end
