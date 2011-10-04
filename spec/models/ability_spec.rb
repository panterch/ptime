require 'spec_helper'

require "cancan/matchers"
require "support/cancan_matchers"
require "support/model_macros"
include ModelMacros

describe "Cancan Security Abilities" do

  context "an anonymous user" do
    describe "on project states" do 
      should_not_have_abilities_for(nil, ProjectState)
    end
    describe "on users" do
      should_not_have_abilities_for(nil, User)
    end
    describe "on projects" do
      should_not_have_abilities_for(nil, Project)
    end
    describe "on entries" do
      should_not_have_abilities_for(nil, Entry)
    end
    describe "on tasks" do
      should_not_have_abilities_for(nil, Task)
    end
  end

  context "authenticated user" do
    before(:each) { @user = Factory :user }
    describe "on own entries" do
      let(:user_entry) { Factory(:entry, :user => @user) }
      specify { @user.should have_ability_to(:create, Entry) }
      specify { @user.should have_ability_to(:read, user_entry) }
      specify { @user.should have_ability_to(:show, user_entry) }
      specify { @user.should have_ability_to(:edit, user_entry) }
      specify { @user.should have_ability_to(:update, user_entry) }
      specify { @user.should have_ability_to(:destroy, user_entry) }
    end
    describe "on other users' entries" do
      let(:other_user) { Factory(:user) }
      let(:other_entry) { Factory(:entry, :user => other_user) }
      specify { @user.should_not have_ability_to(:read, other_entry) }
      specify { @user.should_not have_ability_to(:show, other_entry) }
      specify { @user.should_not have_ability_to(:edit, other_entry) }
      specify { @user.should_not have_ability_to(:update, other_entry) }
      specify { @user.should_not have_ability_to(:destroy, other_entry) }
    end
    describe "on projects" do
      should_not_have_abilities_for(@user, Project)
    end
    describe "on tasks" do
      should_not_have_abilities_for(@user, Task)
    end
  end

  context "admin user" do
    before(:each) { @user = Factory :user, :admin => true }
    let(:user_entry) { Factory(:entry, :user => @user) }
    describe "on own entries" do
      specify { @user.should have_ability_to(:create, Entry) }
      specify { @user.should have_ability_to(:read, user_entry) }
      specify { @user.should have_ability_to(:show, user_entry) }
      specify { @user.should have_ability_to(:edit, user_entry) }
      specify { @user.should have_ability_to(:update, user_entry) }
      specify { @user.should have_ability_to(:destroy, user_entry) }
    end
    describe "on other users' entries" do
      let(:other_user) { Factory(:user) }
      let(:other_entry) { Factory(:entry, :user => other_user) }
      specify { @user.should have_ability_to(:read, other_entry) }
      specify { @user.should have_ability_to(:show, other_entry) }
      specify { @user.should_not have_ability_to(:edit, other_entry) }
      specify { @user.should_not have_ability_to(:update, other_entry) }
      specify { @user.should_not have_ability_to(:destroy, other_entry) }
    end
    describe "on projects" do
      specify { @user.should have_ability_to(:create, Project) }
      specify { @user.should have_ability_to(:index, Project) }
      specify { @user.should have_ability_to(:view, Project) }
      specify { @user.should have_ability_to(:edit, Project) }
      specify { @user.should have_ability_to(:show, Project) }
    end
    describe "on project states" do
      specify { @user.should have_ability_to(:create, ProjectState) }
      specify { @user.should have_ability_to(:index, ProjectState) }
      specify { @user.should have_ability_to(:view, ProjectState) }
      specify { @user.should have_ability_to(:edit, ProjectState) }
      specify { @user.should have_ability_to(:show, ProjectState) }
    end
    describe "on tasks" do
      specify { @user.should have_ability_to(:create, Task) }
      specify { @user.should have_ability_to(:index, Task) }
      specify { @user.should have_ability_to(:view, Task) }
      specify { @user.should have_ability_to(:edit, Task) }
      specify { @user.should have_ability_to(:show, Task) }
    end
  end

end

