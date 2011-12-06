require 'rspec'


class Supermarket
   def initialize
     @price = {:A => 50, :B => 30, :C => 20, :D => 15}
     tuple = Strut.new(:item, :count, :discount)
     discount_A = tuple.new(:A, 3, 130)
     normal_A = tuple.new(:A, 1, 50)
     @token_hash = Hash.new(0)
   end

   def scan(list)
     list.each_char { |c| @token_hash[c.to_sym] += 1 }
   end
   
   def total

     #@token_hash.collect {|item, count| @price[item] * count }.reduce {|sum, item| sum + item }
     #@token_hash.collect {|item, count| @price[item] * count }.reduce {|sum, item| sum + item }
   end
end

describe Supermarket do
  before do
    @checkout = Supermarket.new
  end

  it "scans A for a total of 50" do
    @checkout.scan("A")
    @checkout.total.should == 50
  end

  it "scans B for a total of 30" do
    @checkout.scan("B")
    @checkout.total.should == 30
  end

  it "scans AB for a total of 80" do
    @checkout.scan("AB")
    @checkout.total.should == 80
  end

  it "scans ABC for a total of 100" do
    @checkout.scan("ABC")
    @checkout.total.should == 100
  end

  it "scans CCC for a total of 60" do
    @checkout.scan("CCC")
    @checkout.total.should == 60
  end
  
   it "scans AAA for a total of 130" do
    @checkout.scan("AAA")
    @checkout.total.should == 130
  end               
  
end

