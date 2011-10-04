require 'spec_helper'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

describe "FactoryGirl" do

  it "has a valid user factory" do
    user=Factory.build(:user)
    user.should be_valid
  end

  it 'has a valid accounting factory' do
    accounting = Factory.build(:accounting)
    accounting.should be_valid
  end

  it 'has a valid responsibility factory' do
    responsibility = Factory.build(:responsibility)
    responsibility.should be_valid
  end

  it 'has a valid project factory' do
    project = Factory.build(:project)
    project.responsibilities.count.should eq 2
    project.should be_valid
  end

  it "should not influence other project tests #1" do
    Factory(:project)
    assert_equal 1, Project.count
  end

  it "should not influence other project tests #2" do
    Factory(:project)
    assert_equal 1, Project.count
  end

  it "should not influence other entry tests #1" do
    Factory(:entry)
    assert_equal 1, Entry.count
  end

  it "should not influence other entry tests #2" do
    Factory(:entry)
    assert_equal 1, Entry.count
  end
end
