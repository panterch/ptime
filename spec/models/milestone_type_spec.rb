require 'spec_helper'

describe MilestoneType do
  it 'initializes correctly' do
    MilestoneType.new.should_not be_nil
  end

  context 'validity' do
    before(:each) do
      @milestone_type = Factory.build(:milestone_type)
    end

    it 'should have a name' do
      @milestone_type.name.should_not be_nil
    end
  end

  context 'invalidity' do
    it 'should not be valid without a name' do
      milestone_type = Factory.build(:milestone_type, :name => nil)
      milestone_type.should_not be_valid
      milestone_type.errors[:name].should be_present
    end
  end
end
