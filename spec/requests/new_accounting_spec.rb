require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'New accounting position form', %q{
  As an admin user
  When creating a new accounting position
  I want to receive feedback regarding wrongly supplied values
  In order to correct my errors
} do

  before(:each) do
    log_in :admin => true
    @project = Factory(:project)
    visit "/projects/#{@project.id}/edit"
    click_button 'Add new entry'
  end

  after(:each) do
    log_out
  end

  it 'displays an error message if a parameter is missing', :js => true do
    fill_in 'accounting_description', :with => 'some description'
    click_button 'Create accounting position'
    sleep(2)
    page.all(:css, 'p.inline-errors').count.should eq(2)
  end

  it 'displays a success message if all parameters have been supplied', :js => true do
    fill_in 'accounting_description', :with => 'some description'
    fill_in 'accounting_amount', :with => '3723'
    fill_in 'accounting_valuta', :with => '09/21/2011'
    click_button 'Create accounting position'
    sleep(2)
    page.should_not have_css 'p.inline-errors'
    page.should have_content 'Accounting Positions'
  end
end
