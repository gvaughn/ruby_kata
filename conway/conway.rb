def evolve(generation)
 live_neighbor_stats = generation_stats(generation)
 (live_neighbor_stats[3] || []) + (live_neighbor_stats[2] & generation)
end

def generation_stats(live_cells)
  live_cells.each_with_object(Hash.new {|h,k| h[k] = 0}) {|live_cell, counter|
    neighbors(*live_cell).each {|neighbor| counter[neighbor] += 1 }
  }.each_with_object(Hash.new {|h,k| h[k] = []}) {|(cell, count), collector| collector[count] << cell}
end

def neighbors(x, y)
  [x-1, x, x+1].product([y-1, y, y+1]) - [[x, y]]
end

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

