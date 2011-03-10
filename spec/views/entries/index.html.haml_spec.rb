require 'spec_helper'
include InheritedResourceHelpers

describe "entries/index.html.haml" do
  before(:each) do
    @entries = [Factory(:entry)]
    @active_projects = @entries
    @users = [Factory(:user, :email => "entries_index@example.com")]
    @user = Factory(:user, :email => "entries_index_user@example.com")
    @search = Entry.search()
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
