require 'spec_helper'

describe Entry do
  it "initializes" do
    Entry.new.should_not be_nil
  end

  it "has a valid factory" do
    entry = Factory.build(:entry)
    entry.should be_valid
  end

  it "should not influence other tests #1" do
    Factory(:entry)
    assert_equal 1, Entry.count
  end

  it "should not influence other tests #2" do
    Factory(:entry)
    assert_equal 1, Entry.count
  end

  context "associations" do
    before(:each) do
      @entry = Factory.build(:entry)
    end

    it "should have one associated task" do
      @entry.task_id.should_not be_nil
    end
    it "should have one associated project" do
      @entry.project_id.should_not be_nil
    end
    it "should have one associated user" do
      @entry.user_id.should_not be_nil
    end
    it "should have a description" do
      @entry.description.should_not be_empty
    end
    it "should have a duration" do
      @entry.duration_hours.should_not be_empty
    end
  end

  it "should need a day" do
    entry = Entry.new(:description => "Description",
      :start => Date.parse('2011-01-01'),
      :end => Date.parse('2011-01-03'),
      :task_id => 1,
      :user_id => 1,
      :project_id => 1)
    entry.should_not be_valid
  end
end
