require 'spec_helper'

describe ResponsibilityType do
  it 'initializes correctly' do
    ResponsibilityType.new.should_not be_nil
  end

  context 'validity' do
    before(:each) do
      @responsibility_type = Factory.build(:responsibility_type)
    end

    it 'should have a name' do
      @responsibility_type.name.should_not be_nil
    end
  end

  context 'invalidity' do
    it 'should not be valid without a name' do
      responsibility_type = Factory.build(:responsibility_type, :name => nil)
      responsibility_type.should_not be_valid
      responsibility_type.errors[:name].should be_present
    end
  end
end
