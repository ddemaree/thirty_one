require 'spec_helper'

describe ThirtyOne::RandomPhrase do
  
  describe ".generate" do
    it "generates a random phrase" do
      ThirtyOne::RandomPhrase.stub!(:rand).and_return(0)
      ThirtyOne::RandomPhrase.should_receive(:get_random_value).with("adjectives").and_return("stoned")
      ThirtyOne::RandomPhrase.should_receive(:get_random_value).with("nouns").and_return("redheads")
      # ThirtyOne::RandomPhrase.should_receive(:get_random_value).with("verbs").and_return("stripped")
      # ThirtyOne::RandomPhrase.should_receive(:get_random_value).with("adverbs").and_return("sexily") 
      ThirtyOne::RandomPhrase.generate.should == "2-stoned-redheads"
    end
  end
  
end