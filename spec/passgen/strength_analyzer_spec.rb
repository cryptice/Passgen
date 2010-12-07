require "./lib/passgen"

describe "Using strength analyzer" do

  before do
    srand(2)
  end

  it "should return a StrengthAnalyzer instance" do
    Passgen.analyze("abcdefg").should be_a(Passgen::StrengthAnalyzer)
  end
#  it "should require minimum of 8 characters" do
#    Passgen.analyze("abcdefg")..should == 0
#    Passgen.strength_label("abcdefg").should == "Invalid"
#  end

end
