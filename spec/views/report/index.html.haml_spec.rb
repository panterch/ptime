require 'spec_helper'
include InheritedResourceHelpers
include Devise::TestHelpers

describe "report/index.html.haml" do
  before(:each) do
    @entries = [Factory(:entry), Factory(:entry)]
    @active_projects = [Factory(:project)]
    @users = [Factory(:user)]
    @user = Factory(:user)
    @total_time = "2:0"
    sign_in @user
    @search = Entry.search()
    @tasks_by_project = {"1"=>[{"name"=>"First task","id"=>1}]}
    mock_inherited_resource(@entries)
    # Needed for will_paginate
    @entries.stub!(:total_pages).and_return(1)
  end

  it "renders the entries' username" do
    render
    rendered.should match(/#{@entries[0].user.username}/)
  end

  it "renders a download link for entries" do
    render
    rendered.should match(/report.csv/)
  end

  it "renders the entries' duration" do
    render
    rendered.should match(/#{@entries[0].duration_hours}/)
  end

  it "renders the entries' Task" do
    render
    rendered.should match(/#{@entries[0].task.name}/)
  end

  it "renders the entries' summed up hours" do
    render
    rendered.should match(/Total time.*\d{1,2}:\d{1,2}/)
  end
end
