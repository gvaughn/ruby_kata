require File.dirname(__FILE__) + '/../lib/poker.rb'

describe 'Poker' do
  it '9 should beat 8' do
    Card.new(9).should > Card.new(8)
  end
  
  it 'A should beat K' do
    Card.new('A').should > Card.new('K')
  end
   
end