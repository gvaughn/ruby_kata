module Roman
  MAPPINGS = {
    'i' => 1,
    'v' => 5,
    'iv' => 4,
    'x' => 10,
    'ix' => 9,
    'l' => 50,
    'xl' => 40,
    'c' => 100,
    'xc' => 90
  }
  MINI_LEXER = Regexp.new(MAPPINGS.keys.sort{|a,b| b.length <=> a.length}.join('|'))
  #broken! sorting doesn't work  Well, now it's working...
  # irb doing require 'spec' and load 'roman.rb'
  # 'xliv'.scan(Roman::MINI_LEXER) => ["x", "l", "iv"]
  module StringIncludes
    def arabic
      self.scan(MINI_LEXER).inject(0) {|sum,atom| sum += MAPPINGS[atom]}
    end  
  end
  
  module IntegerIncludes
    Multiplier = Struct.new(:unit, :times1, :times5, :times10) do
      def match(dividend)
        case dividend
        when 0 then ''
        when 9 then times1 + times10
        when 5..8 then times5 + (times1 * (dividend - 5))
        when 4 then times1 + times5
        else times1 * dividend
        end
      end
    end
    
    MULTIPLIERS = [
      Multiplier.new(100, 'c', 'd', 'm'),
      Multiplier.new(10, 'x', 'l', 'c'),
      Multiplier.new(1, 'i', 'v', 'x')
    ]
    
    def roman
      str = ''
      MULTIPLIERS.inject(self) do |divisor, m| 
        dividend, remainder = divisor.divmod m.unit
        str += m.match(dividend)
        dividend == 0 ? divisor : remainder
      end
      str
    end
  end
end

String.send(:include, Roman::StringIncludes)
Integer.send(:include, Roman::IntegerIncludes)


describe 'Roman' do
  {
    'xix' => 19,
    'vii' => 7,
    'xii' => 12,
    'iv' => 4,
    'xcix' => 99,
    'xliv' => 44
    }.each do |input, expect|
       it "should parse #{input} to #{expect}" do
         input.arabic.should == expect
       end
       it "should encode #{expect} as #{input}" do
         expect.roman.should == input
       end
     end
end