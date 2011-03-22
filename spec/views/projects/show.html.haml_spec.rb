require 'spec_helper'
include InheritedResourceHelpers

describe "projects/show.html.haml" do
  before(:each) do
    @project = Factory(:project)
    @project.tasks << Factory(:task)
    mock_inherited_resource(@project)
    render
  end

  it "displays the text attribute of the project" do
    rendered.should =~ /#{@project.shortname}/
  end

  it "should display the associated task(s)" do
    rendered.should =~ /#{@project.tasks.first.name}/
  end

end
