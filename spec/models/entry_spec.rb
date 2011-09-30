require 'spec_helper'

describe Entry do
  it "initializes" do
    Entry.new.should_not be_nil
  end

  it "has a valid factory" do
    entry = Factory.build(:entry)
    entry.should be_valid
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

  context 'Deleting an entry' do
    before(:each) do
      @entry = Factory(:entry)
      @entry.save
      Entry.all.should have(1).record
      @entry.deleted_at.should be_nil
      @entry.mark_as_deleted
    end

    it 'should deactivate the entry instead of deleting it' do
      @entry.deleted_at.should_not be_nil
    end

    it 'should not be selected' do
      Entry.all.should have(:no).records
    end
  end

  context 'invalidity' do
    it 'rejects submission if duration and start are missing' do
      entry = Factory.build(:entry, :duration_hours => nil, :start => nil)
      entry.should_not be_valid
      entry.errors[:start].should be_present
    end

    it 'rejects submission if duration and end are missing' do
      entry = Factory.build(:entry, :duration_hours => nil, :end => nil)
      entry.should_not be_valid
      entry.errors[:end].should be_present
    end

    it 'rejects negative time spans' do
      entry = Factory.build(:entry, :duration_hours => nil, :end => Time.now,
                            :start => Time.now + 1000)
      entry.should_not be_valid
      entry.errors[:start].should be_present
    end

    it 'rejects invalid duration hours format' do
      entry = Factory.build(:entry, :duration_hours => 'abc',
                            :start => nil, :end => nil)
      entry.should_not be_valid
      entry.errors[:duration_hours].should be_present
    end
  end
end
