require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Listing accounting positions as authenticated user', %q{
  When i am an authenticated user i can view all accounting positions.
} do

  scenario 'show accounting positions as authenticated user' do
    project = Factory(:project)
    log_in

    (1..3).each do |num|
      visit "/projects/#{project.id}/accountings/new"
      fill_in 'accounting_description', :with => "accounting position #{num}"
      fill_in 'accounting_amount', :with => "#{num}000"
      fill_in 'accounting_valuta', :with => "0#{num}/21/2011"
      click_button 'Create Accounting'
      page.should_not have_css 'p.inline-errors'
      page.find_by_id('flash_notice').text.should match 'Accounting position successfully created.'
      page.should have_content 'Accounting positions'
    end

    visit '/admin'
    click_link 'Project Maintenance'
    click_link 'abc-123'
    click_link 'View accounting positions'
    page.should have_content 'Accounting positions'
    page.should have_content 'accounting position 1'
    page.should have_content 'accounting position 2'
    page.should have_content 'accounting position 3'
    page.all(:css, 'table.gradient-table > tr').count.should eq(4)
    page.should have_css('table.gradient-table > tr + tr > td')

    log_out
  end
end
