require "./lib/passgen"

describe "Using passgen" do

  before do
    srand(1)
  end
  
  it "should return password with default settings." do
    Passgen::generate.should eql("LRmijlfpaq")
  end

  it "should return password with uppercase chars only" do
    Passgen::generate(:lowercase => false,
                      :digits => false).should eql("FLMIJLFPAQ")
  end
  
  it "should return password with lowercase chars only" do
    Passgen::generate(:uppercase => false,
                      :digits => false).should eql("flmijlfpaq")
  end

  it "should return password with digits only" do
    Passgen::generate(:lowercase => false,
                      :uppercase => false).should eql("5895001769")
  end

  it "should return password with symbols only" do
    Passgen::generate(:lowercase => false,
                      :uppercase => false,
                      :digits => false,
                      :symbols => true).should eql("%?*()?%!!@")
  end

  it "should return password with lowercase and uppercase chars only"

  it "should return password with lowercase and digit chars only"

  it "should return password with lowercase and symbol chars only"

  it "should return password with uppercase and digit chars only"

  it "should return password with uppercase and symbol chars only"

  it "should return password with digit and symbol chars only"

  it "should return password with lowercase, uppercase and digit chars only"

  it "should return password with lowercase, uppercase and symbol chars only"

  it "should return password with lowercase, digit and symbol chars only"

  it "should return password with uppercase, digit and symbol chars only"

  it "should return given number of passwords in an Array"

  it "should return a password with given length"

  it "should return several passwords of variable length"

  it "should use given seed"

  it "should set seed to Time.now + Process.id"
  
end