require 'spec_helper'

describe Accounting do
  it 'initializes correctly' do
    Accounting.new.should_not be_nil
  end

  context 'validity' do
    before(:each) do
      @accounting = Factory.build(:accounting)
    end

    it 'should have one associated project' do
      @accounting.project_id.should_not be_nil
    end

    it 'should have a description' do
      @accounting.description.should_not be_nil
    end

    it 'should have an amount' do
      @accounting.description.should_not be_nil
    end

    it 'should have a valuta date' do
      @accounting.description.should_not be_nil
    end
  end

  context 'invalidity' do
    before(:each) do
      @attributes = Factory(:accounting)
    end

    it 'should not be valid without an associated project' do
      accounting = Accounting.new(:description => @attributes.description, :amount => @attributes.amount, :valuta => @attributes.valuta)
      accounting.should_not be_valid
      accounting.errors[:project].should be_present
    end

    it 'should not be valid without a description' do
      accounting = Accounting.new(:project_id => @attributes.project.id, :amount => @attributes.amount, :valuta => @attributes.valuta)
      accounting.should_not be_valid
      accounting.errors[:description].should be_present
    end

    it 'should not be valid without an amount' do
      accounting = Accounting.new(:description => @attributes.description, :project_id => @attributes.project.id, :valuta => @attributes.valuta)
      accounting.should_not be_valid
      accounting.errors[:amount].should be_present
    end

    it 'should not be valid without a valuta date' do
      accounting = Accounting.new(:project_id => @attributes.project.id, :description => @attributes.description, :amount => @attributes.amount)
      accounting.should_not be_valid
      accounting.errors[:valuta].should be_present
    end
  end

  context 'Deleting an accounting' do
    before(:each) do
      @accounting = Factory(:accounting)
      @accounting.save
      Accounting.all.should have(1).record
      @accounting.deleted_at.should be_nil
      @accounting.mark_as_deleted
    end

    it 'should deactivate the accounting instead of deleting it' do
      @accounting.deleted_at.should_not be_nil
    end

    it 'should not be selected' do
      Accounting.all.should have(:no).records
    end
  end
end
