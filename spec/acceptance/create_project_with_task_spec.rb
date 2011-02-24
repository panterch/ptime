require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Create Project with task", %q{
  In order to have a project associated with a task
  When I am logged in
  I want to create a project
  And I want to create a task alongside with it
} do

  scenario "should create new project with a task" do
    log_in
    project = Factory.build(:project)
    task = Factory.build(:task)
    visit '/projects/new'

    fill_in 'project_name', :with => project.name
    fill_in 'project_description', :with => project.description

    fill_in 'project[tasks_attributes][0][name]', :with => task.name
    click_button 'Create Project'

    current_path.should match %r{/projects/\d+}
    page.should have_content(project.name)
    page.should have_content(project.description)
    page.should have_content(task.name)
  end

end
