require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'New accounting position form', %q{
  As a user
  When creating a new accounting position
  I want to receive feedback regarding wrongly supplied values
  In order to correct my errors
} do

  before(:each) do
    @project = Factory(:project)
    log_in
    visit '/accountings/new'
    select @project.shortname, :from => 'accounting_project_id' 
  end

  after(:each) do
    log_out
  end

  it 'displays an error message if a parameter is missing' do
    fill_in 'accounting_description', :with => 'some description' 
    click_button 'accounting_submit'
    page.all(:css, 'p.inline-errors').count.should eq(2)
  end

  it 'displays a success message if all parameters have been supplied' do
    fill_in 'accounting_description', :with => 'some description' 
    fill_in 'accounting_amount', :with => '3723' 
    fill_in 'accounting_valuta', :with => '09/21/2011' 
    click_button 'accounting_submit'
    page.should_not have_css 'p.inline-errors'
    page.find_by_id('flash_notice').text.should match 'Accounting position successfully created.'
    page.should have_content 'Accounting positions'
  end
end
