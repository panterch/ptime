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

  it "should have many tasks" do
    project = Factory(:project)
    task = Factory(:task)
    project.tasks << task
    assert_equal 1, project.tasks.count
  end

end
