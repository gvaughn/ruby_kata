#Mars Rover Kata

#Develop an api that moves a rover around on a grid.
#You are given the initial starting point (x,y) of a rover and the direction (N,S,E,W) it is facing.
#The rover receives a character array of commands.
#Implement commands that move the rover forward/backward (f,b).
#Implement commands that turn the rover left/right (l,r).
#
#Implement wrapping from one edge of the grid to another. (planets are spheres after all)
#Implement obstacle detection before each move to a new square. If a given sequence of commands encounters an obstacle, the rover moves up to the last possible point and reports the obstacle.

require 'rspec'

describe "Mars Rover" do
	context "starts at 0,0 and facing north" do
		subject do
			MarsRover.new(0,0,"N")
		end

		{'f' => [0,1,'N'],
		 'b' => [0,-1,'N'],
		 'fb' => [0,0,'N'],
		 'l' => [0,0,'W'],
		 'r' => [0,0,'E'],
		 'rl' => [0,0,'N'],
		 'rf' => [1,0,'E'],
		 'rrf' => [0,-1,'S'],
		 'rb' => [-1,0,'E'],
		 'rrbbllffbbbb' => [0,0,'N']
		}.each do |move, expected|
			it "move #{move} should result in #{expected}" do
				subject.move(move).should == expected
			end
		end
	end
end

class MarsRover
	def initialize(x,y,heading)
		@x, @y, @heading = x,y,heading
		@direction = {
			'N' => {'l' => 'W', 'r' => 'E', :multiplier => 1, :dir => :@y},
			'W' => {'l' => 'S', 'r' => 'N', :multiplier => -1, :dir => :@x},
			'S' => {'l' => 'E', 'r' => 'W', :multiplier => -1, :dir => :@y},
			'E' => {'l' => 'N', 'r' => 'S', :multiplier => 1, :dir => :@x}
		}
	end
	
	def move(commands)
		commands.each_char {|c| command(c)}
		[@x, @y, @heading]
	end
	
	private
	
	def command(cmd)
		case(cmd)
			when 'f'
				advance(1)
			when 'b'
				advance(-1)
			when /l|r/
				@heading = @direction[@heading][cmd]
		end
	end
	
	def advance(posneg)
		instructions = @direction[@heading]
		addend = 1 * (posneg * instructions[:multiplier])
		ivar = instructions[:dir]
		instance_variable_set(ivar, instance_variable_get(ivar) + addend)
	end
	
end
