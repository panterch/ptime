require 'spec_helper'

describe User do
  context 'Creating a user' do

    it 'should create the user' do
      Factory(:user)
      User.all.should have(1).record
    end
    it 'should have an admin flag' do
      Factory(:user, :admin => true)
      User.all.first.admin.should be_true
    end
  end

  context 'Deleting a user' do
    before(:each) do
      @user = Factory(:user)
      @user.save
      User.all.should have(1).record
      @user.deleted_at.should be_nil
      @user.destroy
    end

    it 'should deactivate the user instead of deleting it' do
      @user.deleted_at.should_not be_nil
    end

    it 'should not be selected' do
      User.all.should have(:no).records
    end

    it 'should also deactivate the user\'s entries' do
      @user.entries.each do |entry|
        entry.deleted_at.should_not be_nil
      end
    end
  end
end
