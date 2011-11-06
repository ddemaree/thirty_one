require 'spec_helper'

describe ThirtyOne::Party do
  before { DatabaseCleaner.start }
  after  { DatabaseCleaner.clean }

  it "generates a unique code on create" do
    ThirtyOne::RandomPhrase.should_receive(:generate).and_return("3-saucy-calamari")

    new_party = FactoryGirl.build(:party)
    new_party.unique_phrase.should be_blank
    new_party.save

    new_party.unique_phrase.should be_present
    new_party.unique_phrase.should == "3-saucy-calamari"
  end
  
  it "validates at least one bit is a datetime" do
    new_party = FactoryGirl.build(:party, bits: ["dinner.longman_and_eagle"])
    new_party.should_not be_valid
    new_party.errors[:base].should include("You have to choose at least one time when you're available to par-tay")
  end
  
  it "uses the unique phrase as its URL param" do
    party = ThirtyOne::Party.create(name: "David", email: "david@demaree.me")
    party.to_param.should == party.unique_phrase
  end

end