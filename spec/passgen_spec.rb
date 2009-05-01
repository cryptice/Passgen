require "./lib/passgen"

describe "Using passgen" do

  before do
    srand(1)
  end

  it "should return password with default settings." do
    Passgen::generate.should eql("h")
  end

  it "should return capitals only password" do
    Passgen::generate.should eql("h")
  end
end