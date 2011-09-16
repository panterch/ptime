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
    project = Project.new(:shortname => 'title', :description => 'body')
    project.shortname.should be_present
    project.description.should be_present
  end

  it "should require project_state" do
    project = Factory.build(:project, :project_state => nil)
    project.should_not be_valid
    project.errors[:project_state].should be_present
  end

  context "Format validation" do
    it "should discard non-conforming shortnames" do
      project = Factory.build(:project, :shortname => "gross_and_wrong_name")
      project.should_not be_valid
      project.errors[:shortname].should be_present
    end

    it "should accept conforming shortnames" do
      project =  Factory.build(:project, :shortname => "abc-123")
      project.should be_valid
      project.errors[:shortname].should be_empty
    end

    it 'should discard non-conforming probability values' do
      project = Factory.build(:project, :probability => '-15')
      project.should_not be_valid
      project.errors[:probability].should be_present
    end
  end

  context "Mass assignment" do
    before(:each) do
      @project = Factory(:project)
    end

    it "should have a referenced project state" do
      @project.project_state.should_not be_nil
    end

    it "should have default tasks" do
      @project.tasks.should_not be_nil
    end

    it "should delete associated tasks when a parent project is deleted" do
      @project.save
      task_id = @project.tasks[0].id
      @project.destroy
      begin
        assert_equal nil, Task.find(task_id)
      rescue ActiveRecord::RecordNotFound => e
        e.message.should match /Couldn't find Task with id.*/
      end
    end
  end

end
