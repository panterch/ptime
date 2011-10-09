require 'spec_helper'
include Devise::TestHelpers

describe "entries/new.html.haml" do
  before(:each) do
    @user = Factory(:user)
    @entry = Factory(:entry, :day => Time.now)
    @entries = [@entry]
    @project = Factory(:project, :shortname => 'act-000')
    @active_projects = [@project]
    @project_inactive = Factory(:project_inactive, :shortname => 'ina-000')
    sign_in @user
    render
  end

  it "should show active projects" do
    rendered.should match(/#{@project.shortname}/)
  end

  it "shouldn't show inactive projects" do
    rendered.should_not match(/#{@project_inactive.shortname}/)
  end

end
