require "./lib/passgen"

describe "Using passgen" do

  before do
    srand(2)
  end
  
  it "should return password with default settings." do
    Passgen::generate.should eql("OpTiwRslOh")
  end

  it "should return password with uppercase chars only" do
    Passgen::generate(:uppercase => :only).should eql("IPNIWLSLIH")
  end
  
  it "should return password with lowercase chars only" do
    Passgen::generate(:lowercase => :only).should eql("ipniwlslih")
  end

  it "should return password with digits only" do
    Passgen::generate(:digits => :only).should eql("8862872154")
  end

  it "should return password with symbols only" do
    Passgen::generate(:symbols => :only).should eql("))/*#*)(\#@")
  end

  it "should return password with lowercase and uppercase chars only" do
    Passgen::generate(:digits => false).should eql("OpTiwRslOh")
  end

  it "should return password with lowercase and digit chars only" do
    Passgen::generate(:uppercase => false).should eql("piwslh85lv")
  end

  it "should return password with lowercase and symbol chars only" do
    Passgen::generate(:uppercase => false, :digits => false, :symbols => true).should eql("piwslh)&lv")
  end

  it "should return password with uppercase and digit chars only" do
    Passgen::generate(:lowercase => false).should eql("PIWSLH85LV")
  end

  it "should return password with uppercase and symbol chars only" do
    Passgen::generate(:lowercase => false, :digits => false, :symbols => true).should eql("PIWSLH)&LV")
  end

  it "should return password with digit and symbol chars only" do
    Passgen::generate(:lowercase => false, :uppercase => false, :symbols => true).should eql("8&$8@)@872")
  end

  it "should return password with lowercase, uppercase and digit chars only" do
    Passgen::generate.should eql("OpTiwRslOh")
  end

  it "should return password with lowercase, uppercase and symbol chars only" do
    srand(3)
    Passgen::generate(:digits => false, :symbols => true).should eql("Qy&d%iav+t")
  end

  it "should return password with lowercase, digit and symbol chars only" do
    srand(4)
    Passgen::generate(:uppercase => false, :symbols => true).should eql("?fb%xij$+4")
  end

  it "should return password with uppercase, digit and symbol chars only" do
    srand(4)
    Passgen::generate(:lowercase => false, :symbols => true).should eql("?FB%XIJ$+4")
  end
  
  it "should return given number of passwords in an Array" do
    Passgen::generate(:number => 3).should eql("j")
  end

  it "should return a password with given length"

  it "should return several passwords of variable length"

  it "should use given seed"

  it "should set seed to Time.now + Process.id"
  
end