require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Edit a project', %q{
  When i am a admin i can edit a project's properties.
} do

  before(:each) do
    log_in :admin=>true
    @project = Factory(:project)
    visit "/projects/#{@project.id}/edit"
  end

  after(:each) do
    log_out
  end

  scenario 'edit probability in steps of 10 in range from 0 to 100' do
    select '20%', :from => 'project_probability'
    click_button 'Update Project'
    page.should have_content 'Successfully updated project.'
    page.should_not have_css '.inline-errors'
  end
end
