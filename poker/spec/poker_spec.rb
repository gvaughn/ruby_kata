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

    first = cards[0]

    second = cards[1]

    it "#{first} should beat #{second}" do
      Card.new(first).should > Card.new(second)
    end
  end
end
