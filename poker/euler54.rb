#! /usr/bin/env ruby

require './lib/hand.rb'
require './lib/card.rb'

winner = []

winner = File.readlines('poker.txt').collect do |line|
  Hand.new(line[0,14]) <=> Hand.new(line[15,14])
end

p "Player 1 won #{winner.find_all {|i| i == 1}.count}"
p "Player 2 won #{winner.find_all {|i| i == -1}.count}"