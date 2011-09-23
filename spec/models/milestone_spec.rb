require 'spec_helper'

describe Milestone do
  it 'initlialized correctly' do
    Milestone.new.should_not be_nil
  end

  context 'validity' do
    before(:each) do
      @milestone = Factory.build(:milestone)
    end

    it 'should have a milestone_type ID' do
      @milestone.milestone_type_id.should_not be_nil
    end

    it 'should have a project ID' do
      @milestone.project_id.should_not be_nil
    end
  end

  context 'invalidity' do
    it 'should not be valid without an associated milestone type' do
      milestone = Factory.build(:milestone, :milestone_type_id => nil)
      milestone.should_not be_valid
      milestone.errors[:milestone_type].should be_present
    end

    it 'should not be valid without an associated project' do
      milestone = Factory.build(:milestone, :project_id => nil)
      milestone.should_not be_valid
      milestone.errors[:project].should be_present
    end
  end

  context 'Deleting a milestone' do
    before(:each) do
      @milestone = Factory(:milestone)
      @milestone.save
      Milestone.all.should have(1).record
      @milestone.deleted_at.should be_nil
      @milestone.mark_as_deleted
    end

    it 'should deactivate the milestone instead of deleting it' do
      @milestone.deleted_at.should_not be_nil
    end

    it 'should not be selected' do
      Milestone.all.should have(:no).records
    end
  end
end
