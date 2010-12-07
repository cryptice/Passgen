require "./lib/passgen"

describe "Using strength analyzer" do

  before do
    srand(2)
  end

  it "should return a StrengthAnalyzer instance" do
    Passgen.analyze("abcdefg").should be_a(Passgen::StrengthAnalyzer)
  end
  
  it "should require minimum of 8 characters" do
    sa = Passgen.analyze("abcdefg")
    sa.score.should == 0
    sa.complexity.should == "Invalid"
    sa.errors.should == ["Password must be at least 8 characters long"]
  end

  it "should analyze aaaaaaaa correctly" do
    sa = Passgen.analyze("aaaaaaaa")
    sa.score.should == 0
    sa.complexity.should == "Trivial"
    sa.errors.should == []
  end

  it "should analyze aaaaAAAA correctly" do
    sa = Passgen.analyze("aaaaAAAA")
    sa.score.should == 0
    sa.complexity.should == "Trivial"
    sa.errors.should == []
  end

  it "should analyze aaaAAA11 correctly" do
    sa = Passgen.analyze("aaaAAA11")
    sa.score.should == 35
    sa.complexity.should == "Weak"
    sa.errors.should == []
  end

  it "should analyze aaa1AAA1 correctly" do
    sa = Passgen.analyze("aaa1AAA1")
    sa.score.should == 38
    sa.complexity.should == "Weak"
    sa.errors.should == []
  end
end
