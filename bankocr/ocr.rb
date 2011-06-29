# http://codingdojo.org/cgi-bin/wiki.pl?KataBankOCR

module BankOCR
  MAPPINGS = {
    /^ _/ => 0,
    /^  / => 1,
    /^_/ => 2,
  }

  NUMBERS = <<-END.gsub(/^ {4}/,'')
     _    | ___
    | |   | __|
    |_|   | |__
  END

  def NUMBERS.[](n)
    self.split('\n').collect {|line| line[4*n, 3]} * '\n'
  end

  def ocr
    BankOCR::MAPPINGS.detect{|k,v| self =~ k}[1]
  end  
end

String.send(:include, BankOCR)

describe 'OCR' do
  (0..2).each do |n|
    it "should parse #{n}" do
      BankOCR::NUMBERS[n].ocr.should be n
    end
  end
end

