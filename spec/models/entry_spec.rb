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

  context 'CSV export' do
    it 'generates comma separated values' do
      entry = Factory(:entry)
      csv = entry.to_csv
      csv.count(',').should eq(6)
      csv.should include(entry.project.shortname)
      csv.should include(entry.user.username)
      csv.should include(entry.day.to_s)
      csv.should include(entry.duration_hours)
      csv.should include(entry.task.name)
      csv.should include(entry.description)
      csv.should include(entry.billable.to_s)
    end

    it 'handles commas correctly' do
      entry = Factory(:entry, :description => 'a,b')
      csv = entry.to_csv
      csv.count(',').should eq(7)
      csv.should include("\"#{entry.description}\"")
    end
  end
end
