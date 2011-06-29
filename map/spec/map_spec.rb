require 'rspec'

class Point
  attr :x, :y
  def initialize(x,y)
    @x, @y = x, y
  end
  
  def <=>(other)
    self.x <=> other.x && self.y <=> other.y
  end
  
  def to_a
    [x, y]
  end
end

class Map
  def initialize(sizex,sizey)
    @size = Point.new(sizex, sizey)
  end
  
  def initial_location(x,y)
    @i = Point.new(x,y)
  end
  
  def bounds_filter(*args)
    args.reject do |point|
      point.x < 1 || point.x > @size.x || point.y < 1 || point.y > @size.y
    end
  end
  
  def available_spaces(moves)
    results = [@i]
    moves.times do 
      results = results | step(results)
    end
    results.collect(&:to_a).uniq
  end
  
  def step(args)
    args.collect do |p|
      bounds_filter(Point.new(p.x-1,p.y),Point.new(p.x+1,p.y),
        Point.new(p.x,p.y-1),Point.new(p.x,p.y+1))
    end.flatten
  end
end

describe Map do
  context "on 5x5 grid" do
    before do
      @map = Map.new(5,5)
    end
    context "starting at 3,3" do
      before do
        @map.initial_location(3,3)
      end
      
      it "has empty set for 0 moves" do
        @map.available_spaces(0).should == [[3,3]]
      end
      it "has 4 available spaces for 1 move" do
        @map.available_spaces(1).should =~ [[3,3],[2,3],[4,3],[3,2],[3,4]]
      end
    end
    context 'starting at 2,2' do
      before do
        @map.initial_location(2,2)
      end
      it 'has 4 available spaces for 1 move' do
        @map.available_spaces(1).should =~ [[2,2],[1,2],[3,2],[2,1],[2,3]]
      end
    end
    context 'starting at 1,1' do
      before do
        @map.initial_location(1,1)
      end
      it 'has 4 available spaces for 1 move' do
        @map.available_spaces(1).should =~ [[1,1],[1,2],[2,1]]
      end
      
      it "has 6 available spaces for 2 moves" do
        @map.available_spaces(2).should =~ [[1,1],[1,2],[2,1],[2,2],[3,1],[1,3]]
      end
    end
  end
end
