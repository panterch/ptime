require 'spec_helper'
include InheritedResourceHelpers

describe "entries/new.html.haml" do
  before(:each) do
    @entry = Factory(:entry)
    @project = Factory(:project)
    @project_inactive = Factory(:project_inactive)
    mock_inherited_resource(@entry)
  end

  it "should show active projects" do
    render
    rendered.should match(/#{@project.name}/)
  end

  it "shouldn't show inactive projects" do
    rendered.should_not match(/#{@project_inactive.name}/)
  end

end
