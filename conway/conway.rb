def evolve(generation)
 live_neighbor_stats = generation_stats(generation)
 (live_neighbor_stats[3] || []) + (live_neighbor_stats[2] & generation)
end

def generation_stats(live_cells)
  live_cells.each_with_object(Hash.new(0),                &method(:cell_neighbor_counts)).
             each_with_object(Hash.new {|h,k| h[k] = []}, &method(:neighbor_count_cells))
end

def cell_neighbor_counts(live_cell, accumulator)
  neighbors(*live_cell).each {|neighbor| accumulator[neighbor] += 1 }
end

def neighbor_count_cells((cell, count), collector)
  collector[count] << cell
end

def neighbors(x, y)
  [x-1, x, x+1].product([y-1, y, y+1]) - [[x, y]]
end

#NOTE: a parallel Elixir version can be found
# https://github.com/gvaughn/elixir_kata/blob/master/conway/lib/conway.ex

describe "Conway's Game of Life" do
 it "handles static block object" do
   block = [[0,1], [1,1],
            [0,0], [1,0]
   ]
   evolve(block).should =~ block
 end

 it "handles a blinker" do
   blinker_a = [       [1,2],
                       [1,1],
                       [1,0]
   ]
   blinker_b = [[0,1], [1,1], [2,1]
   ]
   evolve(blinker_a).should =~ blinker_b
   evolve(blinker_b).should =~ blinker_a
 end

 it "handles a toad" do
   toad_a = [       [1,1], [2,1], [3,1],
             [0,0], [1,0], [2,0]
   ]
   toad_b = [              [2,2],
            [0,1],                [3,1],
            [0,0],                [3,0],
                   [1,-1]
   ]
   evolve(toad_a).should =~ toad_b
   evolve(toad_b).should =~ toad_a
 end
end

