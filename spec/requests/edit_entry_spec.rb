require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Edit a entry", %q{
  As a user
  When viewing my entries
  I want to be able to edit past entries
} do

  before(:each) do
    @project = Factory(:project)
    task = Factory(:task, :project_id => @project.id)
    log_in
  end

  after(:each) do
    log_out
  end

  it 'loads the filled in and calculated values of the entry', :js => true do
    select @project.shortname, :from => 'entry_project_id'
    select 'First task', :from => 'entry_task_id'
    fill_in 'entry_start', :with => '06:05'
    fill_in 'entry_end', :with => '22:15'
    fill_in 'entry_description', :with => 'my entry for today'
    click_button 'Create Entry'

    page.find(:css, 'table.gradient-table > tbody > tr > td > a > img').click
    page.find_by_id('entry_start').value.should match '06:05'
    page.find_by_id('entry_end').value.should match '22:15'
    page.find_by_id('entry_duration_hours').value.should match '16:10'
  end
end
