class Integer
	def primes(factors = []) #from largest to smallest == faster
	  return [] if self <= 1
	  factor = (Math.sqrt(self).floor).downto(2).detect {|f| self % f == 0}
	  factor ? factors + (self/factor).primes(factors) + factor.primes : [self]
	end
end

def generate_tail(n, factors=[]) #http://www.benrady.com/2009/12/katarubytail-recursive-prime-factors.html
  return factors if n == 1
  new_factor = (2..n).find {|f| n % f == 0} 
  generate_tail(n / new_factor, factors + [new_factor])
end

def generate(n) #http://www.benrady.com/2009/11/katarubyprime-factors.html
  return [] if n == 1
  factor = (2..n).find {|x| n % x == 0} 
  [factor] + generate(n / factor) 
end

	
describe Integer do
  {0 => [],
   1 => [],
   2 => [2],
   3 => [3],
   6 => [3,2],
   4 => [2,2],
   12 => [2,2,3],
   21 => [7,3],
   16 => [2,2,2,2],
   150 => [5,5,3,2],
   170 => [17,2,5],
   216 => [3,3,3,2,2,2],
   612 => [2,2,3,3,17],
   1024 => Array.new(10, 2),
   }.each do |given, expect|
     it "#{given} should have [#{expect.join(',')}] as primes" do
       given.primes.should =~ expect
       #generate(given).should =~ expect
     end
   end
end
