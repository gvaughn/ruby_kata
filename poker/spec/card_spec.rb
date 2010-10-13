require File.dirname(__FILE__) + '/../lib/card.rb'

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
  end

  it "card has suit" do
    Card.new('KH').suit == Card.new('5H').suit
  end

end
