require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Listing accounting positions as authenticated user', %q{
  When i am an authenticated user i can view all accounting positions.
} do

  scenario 'show accounting positions as authenticated user' do
    project = Factory(:project)
    log_in :admin=>true

    accounting_one = Factory(:accounting, :description => 'accounting position 1', :project_id => project.id)
    accounting_two = Factory(:accounting, :description => 'accounting position 2', :project_id => project.id)
    accounting_three = Factory(:accounting, :description => 'accounting position 3', :project_id => project.id)

    visit '/admin'
    click_link 'Project Maintenance'
    click_link 'abc-123'
    click_link 'View accounting positions'
    page.should have_content 'Accounting positions'
    page.should have_content 'accounting position 1'
    page.should have_content 'accounting position 2'
    page.should have_content 'accounting position 3'
    page.all(:css, 'table.gradient-table > tr').count.should eq(3)
    page.should have_css('table.gradient-table > tr + tr > td')

    log_out
  end
end
