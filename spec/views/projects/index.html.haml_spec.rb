require 'spec_helper'

describe "projects/index.html.haml" do
  before(:each) do
    @project = Factory(:project)
    @project_states = Factory(:project_state)
    assign(:search, Project.search({}))
    assign(:projects, [@project])
    assign(:project_states, [@project_states] )
    view.stub(:search).and_return( { "meta_sort" => "shortname.asc" } )
    render
  end

  it "displays the text attribute of the project" do
    rendered.should =~ /#{@project.shortname}/
  end

  it "should display the project's description" do
    rendered.should =~ /#{@project.description}/
  end

end
