require 'spec_helper'

describe ProjectState do

  it "initializes" do
    ProjectState.new.should_not be_nil
  end

  it "should allow mass assignement for name" do
    project_state = ProjectState.new(:name => 'new project state')
    project_state.name.should be_present
  end

  it "should allow mass assignement for position" do
    project_state = ProjectState.new(:name => 'new project state', :position => 1)
    project_state.position.should be_present
  end

end
