require 'spec_helper'

describe ThirtyOne::Party do

  before { ThirtyOne::Party.delete_all; ThirtyOne::PartyBit.delete_all }

  it "generates a unique code on create" do
    ThirtyOne::RandomPhrase.should_receive(:generate).and_return("3-saucy-calamari")

    new_party = ThirtyOne::Party.new
    new_party.name = "David Demaree"
    new_party.email = "david@demaree.me"
    new_party.save

    new_party.unique_phrase.should be_present
    new_party.unique_phrase.should == "3-saucy-calamari"
  end
  
  it "uses the unique phrase as its URL param" do
    party = ThirtyOne::Party.create(name: "David", email: "david@demaree.me")
    party.to_param.should == party.unique_phrase
  end

end