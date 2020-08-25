require "./spec_helper"

describe Obscenity do
  # TODO: Write tests

  it "respond to methods and attributes" do
    # [:configure, :config, :profane?, :sanitize, :offensive, :replacement].each do |field|
      Obscenity.responds_to?(:configure).should eq(true)
      Obscenity.responds_to?(:config).should eq(true)
      Obscenity.responds_to?(:profane?).should eq(true)
      Obscenity.responds_to?(:sanitize).should eq(true)
      Obscenity.responds_to?(:offensive).should eq(true)
      Obscenity.responds_to?(:replacement).should eq(true)
    # end
  end

  it "should accept a configuration block" do
    Obscenity.configure -> (config : Obscenity::Config) {
      config.blacklist   = :default
      config.replacement = :garbled
    }
  end

  it "should return the current config object" do
    Obscenity.config.should_not eq(nil)
  end

  it "should validate the profanity of the given content" do
    Obscenity.profane?("Yo, check that ass out").should eq(true)
  end

  it "should sanitize the given content" do
    Obscenity.sanitize("Yo, check that ass out").should eq("Yo, check that $@!#% out")
    Obscenity.sanitize("Hello world").should eq("Hello world")
  end

  it "should return the offensive words for the given content" do
    Obscenity.offensive("Yo, check that ass biatch").should eq(["ass", "biatch"])
  end

  it "should sanitize the given content based on the given replacement" do
    Obscenity.replacement(:garbled).sanitize("Yo, check that ass out").should eq("Yo, check that $@!#% out")
    Obscenity.replacement(:default).sanitize("Yo, check that ass out").should eq("Yo, check that $@!#% out")
    Obscenity.replacement(:vowels).sanitize("Yo, check that ass out").should eq("Yo, check that *ss out")
    Obscenity.replacement(:nonconsonants).sanitize("Yo, check that 5hit out").should eq("Yo, check that *h*t out")
    Obscenity.replacement(:stars).sanitize("Yo, check that ass out").should eq("Yo, check that *** out")
    Obscenity.replacement("[censored]").sanitize("Yo, check that ass out").should eq("Yo, check that [censored] out")
    Obscenity.sanitize("Hello world").should eq("Hello world")
  end
end
