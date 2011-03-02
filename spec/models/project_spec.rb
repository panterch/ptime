require 'spec_helper'

describe Project do

  it "initializes" do
    Project.new.should_not be_nil
  end

  it "has a valid factory" do
    project = Factory.build(:project)
    project.should be_valid
  end

  it "should allow mass assignement for title and body" do
    project = Project.new(:name => 'title', :description => 'body')
    project.name.should be_present
    project.description.should be_present
  end

  it "should not influence other tests #1" do
    Factory(:project)
    assert_equal 1, Project.count
  end

  it "should not influence other tests #2" do
    Factory(:project)
    assert_equal 1, Project.count
  end

  it "should create a task via mass assignement" do
    @project = Project.new(:name => "First project",
               :description => "First description", 
               :start => Time.now,
               :end => Time.now+2.days,
               :tasks_attributes => [{ :name => "First task",
                                       :inactive => false}])
    @project.tasks.should_not be_empty
  end

end
