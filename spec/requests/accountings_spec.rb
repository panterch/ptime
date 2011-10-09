require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Listing accounting positions as authenticated user', %q{
  When i am an authenticated user i can view all accounting positions.
} do

  scenario 'show accounting positions as authenticated user' do
    log_in :admin=>true
    project = Factory(:project, :shortname => 'abc-001', :description => '123')

    accounting_one = Factory(:accounting,
                             :description => 'accounting position 1',
                             :project_id => project.id)
    accounting_two = Factory(:accounting,
                             :description => 'accounting position 2',
                             :project_id => project.id)
    accounting_three = Factory(:accounting,
                               :description => 'accounting position 3',
                               :project_id => project.id)

    visit projects_path
    click_link 'abc-001 - 123'
    page.should have_content 'Accounting Positions'
    page.should have_content 'accounting position 1'
    page.should have_content 'accounting position 2'
    page.should have_content 'accounting position 3'
    page.all(:css, 'table.accountings > tr').count.should eq(3)
    page.should have_css('table.accountings > tr + tr > td')

    log_out
  end
end
