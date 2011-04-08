require 'spec_helper'
include InheritedResourceHelpers

describe "projects/index.html.haml" do
  before(:each) do
    @project = Factory(:project)
    mock_inherited_resource(@project)
    view.stub(:sort_column).and_return("shortname")
    view.stub(:sort_direction).and_return("asc")
    render
  end

  it "displays the text attribute of the project" do
    rendered.should =~ /#{@project.shortname}/
  end

  it "should display the project's description" do
    rendered.should =~ /#{@project.description}/
  end

end
