require 'spec_helper'
include InheritedResourceHelpers

describe "entries/show.html.erb" do
  before(:each) do
    @entry = Factory(:entry)
    mock_inherited_resource(@entry)
  end

  it "renders attributes" do
    render
    rendered.should match(/#{@entry.user.username}/)
    rendered.should match(/#{@entry.project.name}/)
    rendered.should match(/#{@entry.task.name}/)
    rendered.should match(/#{@entry.description}/)
  end
end
