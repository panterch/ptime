require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Listing accounting positions as authenticated user', %q{
  When i am an authenticated user i can view all accounting positions.
} do

  scenario 'show accounting positions as authenticated user' do
    project = Factory(:project)
    log_in

    pending 'use it_should_behave_like/shared_examples_for'
    # create a accounting position
    visit '/controlling/accountings/new'
    select project.shortname, :from => 'accounting_project_id'
    fill_in 'accounting_description', :with => 'some description'
    fill_in 'accounting_amount', :with => '3723'
    fill_in 'accounting_valuta', :with => '09/21/2011'
    click_button 'accounting_submit'
    page.should_not have_css 'p.inline-errors'
    page.find_by_id('flash_notice').text.should match 'Accounting position successfully created.'
    page.should have_content 'Accounting positions'

    visit '/'
    click_link 'Accouting'
    page.should have_content 'Accounting positions'
    page.should have_content 'some description'
    page.should have_css('table.gradient-table > tr + tr > td')

    log_out
  end
end
