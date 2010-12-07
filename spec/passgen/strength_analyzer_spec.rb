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

  it "should analyze hht14AAA correctly" do
    sa = Passgen.analyze("hht14AAA")
    sa.score.should == 57
    sa.complexity.should == "Good"
    sa.errors.should == []
  end
  
  it "should analyze hie14KOL correctly" do
    sa = Passgen.analyze("hie14KOL")
    sa.score.should == 62
    sa.complexity.should == "Strong"
    sa.errors.should == []
  end
  
  it "should analyze hI&14KoL correctly" do
    sa = Passgen.analyze("hI&14KoL")
    sa.score.should == 82
    sa.complexity.should == "Very Strong"
    sa.errors.should == []
  end

  it "should analyze hI&1#4KoL correctly" do
    sa = Passgen.analyze("hI&1#4KoL")
    sa.score.should == 100
    sa.complexity.should == "Very Strong"
    sa.errors.should == []
  end
end
