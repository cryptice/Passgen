module Passgen
  class StrengthAnalyzer
    
    def initialize(pw)
      @password = pw
      @score = 0
      @status = "Invalid"
      @errors = []
    end
    
    def self.analyze(pw)
      sa = StrengthAnalyzer.new(pw)
      sa
    end
  end
end