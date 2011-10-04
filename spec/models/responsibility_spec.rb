require 'spec_helper'

describe Responsibility do
  it 'initializes correctly' do
    Responsibility.new.should_not be_nil
  end

  context 'validity' do
    before(:each) do
      @responsibility = Factory.build(:responsibility)
    end

    it 'should have one associated project' do
      @responsibility.project_id.should_not be_nil
    end

    it 'should have one associated responsibility type' do
      @responsibility.responsibility_type_id.should_not be_nil
    end
  end

  context 'invalidity' do
    before(:each) do
      @attributes = Factory(:responsibility)
    end

    it 'should not be valid without an responsibility type' do
      responsibility = Responsibility.new(:responsibility_type => nil)
      responsibility.should_not be_valid
      responsibility.errors[:responsibility_type].should be_present
    end
  end

  context 'Deleting a responsibility' do
    before(:each) do
      @responsibility = Factory(:responsibility)
      @responsibility.save
      # The associated project implies the two default responsibilities, thus
      # there should be three in total here
      Responsibility.all.should have(3).record
      @responsibility.deleted_at.should be_nil
      @responsibility.mark_as_deleted
    end

    it 'should deactivate the responsibility instead of deleting it' do
      @responsibility.deleted_at.should_not be_nil
    end

    it 'should not be selected' do
      Responsibility.all.should have(2).records
    end
  end
end
