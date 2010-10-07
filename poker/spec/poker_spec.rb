require File.dirname(__FILE__) + '/../lib/poker.rb'

describe 'Poker' do
  describe Card do
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
  
    it "equivalently accepts int or string card values" do
      Card.new('9').should == Card.new(9)
    end
  
    it "accepts suit" do
      Card.new('KH').suit == Card.new('5H').suit
    end
    
  end
end
