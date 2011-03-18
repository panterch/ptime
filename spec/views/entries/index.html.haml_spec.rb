require 'spec_helper'
include InheritedResourceHelpers
include Devise::TestHelpers

describe "entries/index.html.haml" do
  before(:each) do
    @entries = [Factory(:entry)]
    @active_projects = [Factory(:project)]
    @users = [Factory(:user)]
    @user = Factory(:user)
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
    rendered.should match(/entries.csv/)
  end

  it "renders the entries' duration" do
    render
    rendered.should match(/#{@entries[0].duration_hours}/)
  end
end
