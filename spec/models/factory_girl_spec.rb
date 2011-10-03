require 'spec_helper'

describe "FactoryGirl" do

  it "has a valid user factory" do
    user=Factory.build(:user)
    user.should be_valid
  end


end
