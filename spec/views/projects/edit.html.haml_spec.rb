require 'spec_helper'

describe "projects/edit.html.haml" do
  before(:each) do
    @project = Factory(:project)
    @project.tasks << Factory(:task)
    render
  end

  it "displays the text attribute of the project" do
    rendered.should =~ /#{@project.shortname}/
  end

  it "should not be the form to new" do
    rendered.should_not =~ /new_project/
  end

  it "should display the associated task(s)" do
    rendered.should =~ /#{@project.tasks.first.name}/
  end

end
