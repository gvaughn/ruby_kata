require File.dirname(__FILE__) + '/../lib/poker.rb'

describe 'Poker' do
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
  ].each do |cards|
    it "#{cards[0]} should beat #{cards[1]}" do
      Card.new(cards[0]).should > Card.new(cards[1])
    end
  end
end
