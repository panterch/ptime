require 'spec_helper'
include InheritedResourceHelpers

describe "entries/index.csv.haml" do

  let (:entry) { Factory(:entry, :user => Factory(:user)) }
  before(:each) do
    @entries_csv = [entry.day, entry.duration_hours, entry.project.shortname,
      entry.user.username].join(',')
    @search = Entry.search()
    mock_inherited_resource(@entries_csv)
  end

  it "renders the entries' username" do
    render
    rendered.should match(/#{entry.user.username}/)
  end

  it "renders the entries' duration" do
    render
    rendered.should match(/#{entry.duration_hours}/)
  end

  it "renders the entries' project" do
    render
    rendered.should match(/#{entry.project.shortname}/)
  end
end
