require 'spec_helper'
include InheritedResourceHelpers

describe "entries/new.html.haml" do
  before(:each) do
    @entry = Factory(:entry)
    @project = Factory(:project)
    @active_projects = [@project.shortname, @project.id]
    @project_inactive = Factory(:project_inactive)
    mock_inherited_resource(@entry)
  end

  it "should show active projects" do
    render
    rendered.should match(/#{@project.shortname}/)
  end

  it "shouldn't show inactive projects" do
    rendered.should_not match(/#{@project_inactive.shortname}/)
  end

end
