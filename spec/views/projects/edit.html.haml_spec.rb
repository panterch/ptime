require 'spec_helper'
include InheritedResourceHelpers

describe "projects/edit.html.haml" do
  before(:each) do
    @project = Factory(:project)
    @project.tasks << Factory(:task)
    mock_inherited_resource(@project)
    render
  end

  it "displays the text attribute of the project" do
    rendered.should =~ /#{@project.name}/
  end

  it "should not be the form to new" do
    rendered.should_not =~ /new_project/
  end

  it "should display the associated task(s)" do
    rendered.should =~ /#{@project.tasks.first.name}/
  end

end
