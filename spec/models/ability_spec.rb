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
    describe 'on accountings' do
      should_not_have_abilities_for(nil, Accounting)
    end
    describe 'on milestones' do
      should_not_have_abilities_for(nil, Milestone)
    end
    describe 'on milestone types' do
      should_not_have_abilities_for(nil, MilestoneType)
    end
    describe 'on responsibilities' do
      should_not_have_abilities_for(nil, Responsibility)
    end
    describe 'on responsibility types' do
      should_not_have_abilities_for(nil, ResponsibilityType)
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
    describe 'on other users' do
      let(:other_user) { Factory(:user) }
      specify { @user.should_not have_ability_to(:read, other_user) }
      specify { @user.should_not have_ability_to(:show, other_user) }
      specify { @user.should_not have_ability_to(:edit, other_user) }
      specify { @user.should_not have_ability_to(:update, other_user) }
      specify { @user.should_not have_ability_to(:destroy, other_user) }
    end
    describe 'on own user' do
      specify { @user.should_not have_ability_to(:create, User) }
      specify { @user.should have_ability_to(:read, @user) }
      specify { @user.should have_ability_to(:show, @user) }
      specify { @user.should have_ability_to(:edit, @user) }
      specify { @user.should have_ability_to(:update, @user) }
      specify { @user.should_not have_ability_to(:destroy, @user) }
    end
    describe 'on accountings' do
      should_not_have_abilities_for(@user, Accounting)
    end
    describe 'on milestones' do
      should_not_have_abilities_for(@user, Milestone)
    end
    describe 'on milestone types' do
      should_not_have_abilities_for(@user, MilestoneType)
    end
    describe 'on responsibilities' do
      should_not_have_abilities_for(@user, Responsibility)
    end
    describe 'on responsibility types' do
      should_not_have_abilities_for(@user, ResponsibilityType)
    end
    describe 'on project states' do
      should_not_have_abilities_for(@user, ProjectState)
    end
  end

  context "admin user" do
    before(:each) { @user = Factory :user, :admin => true }
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
    describe 'on own user' do
      specify { @user.should have_ability_to(:create, User) }
      specify { @user.should have_ability_to(:read, @user) }
      specify { @user.should have_ability_to(:show, @user) }
      specify { @user.should have_ability_to(:edit, @user) }
      specify { @user.should have_ability_to(:update, @user) }
      specify { @user.should_not have_ability_to(:destroy, @user) }
    end
    describe 'on other user' do
      let(:other_user) { Factory(:user) }
      specify { @user.should have_ability_to(:read, other_user) }
      specify { @user.should have_ability_to(:show, other_user) }
      specify { @user.should have_ability_to(:edit, other_user) }
      specify { @user.should have_ability_to(:update, other_user) }
      specify { @user.should have_ability_to(:destroy, other_user) }
    end
    describe 'on accountings' do
      specify { @user.should have_ability_to(:create, Accounting) }
      specify { @user.should have_ability_to(:index, Accounting) }
      specify { @user.should have_ability_to(:view, Accounting) }
      specify { @user.should have_ability_to(:edit, Accounting) }
      specify { @user.should have_ability_to(:show, Accounting) }
      specify { @user.should have_ability_to(:destroy, Accounting) }
    end
    describe 'on milestones' do
      specify { @user.should have_ability_to(:create, Milestone) }
      specify { @user.should have_ability_to(:index, Milestone) }
      specify { @user.should have_ability_to(:view, Milestone) }
      specify { @user.should have_ability_to(:edit, Milestone) }
      specify { @user.should have_ability_to(:show, Milestone) }
      specify { @user.should have_ability_to(:destroy, Milestone) }
    end
    describe 'on milestone types' do
      specify { @user.should have_ability_to(:create, MilestoneType) }
      specify { @user.should have_ability_to(:index, MilestoneType) }
      specify { @user.should have_ability_to(:view, MilestoneType) }
      specify { @user.should have_ability_to(:edit, MilestoneType) }
      specify { @user.should have_ability_to(:show, MilestoneType) }
      specify { @user.should_not have_ability_to(:destroy, MilestoneType) }
    end
    describe 'on responsibilities' do
      specify { @user.should have_ability_to(:create, Responsibility) }
      specify { @user.should have_ability_to(:index, Responsibility) }
      specify { @user.should have_ability_to(:view, Responsibility) }
      specify { @user.should have_ability_to(:edit, Responsibility) }
      specify { @user.should have_ability_to(:show, Responsibility) }
      specify { @user.should have_ability_to(:destroy, Responsibility) }
    end
    describe 'on responsibility types' do
      specify { @user.should have_ability_to(:create, ResponsibilityType) }
      specify { @user.should have_ability_to(:index, ResponsibilityType) }
      specify { @user.should have_ability_to(:view, ResponsibilityType) }
      specify { @user.should have_ability_to(:edit, ResponsibilityType) }
      specify { @user.should have_ability_to(:show, ResponsibilityType) }
      specify { @user.should_not have_ability_to(:destroy, ResponsibilityType) }
    end
  end
end
