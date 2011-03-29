require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "New entry form", %q{
  As a user
  When creating a new entry
  I want the application to help me with ergonomic measures
  In order to use the UI efficiently
} do

  before(:each) do
    @project = Factory(:project)
    log_in
    select @project.shortname, :from => 'entry_project_id' 
  end

  after(:each) do
    log_out
  end

  # FIXME: Why does this test fail? It works in the browser, but not with
  # selenium.
  it "it calculates the duration when given start and end time", :js => true do
    fill_in "entry_start", :with => "06:05 AM" 
    fill_in "entry_end", :with => "10:15 PM" 
    # FIXME: This line is an attempt to force the event onchange. It doesn't
    # help. It is left solely for the purpose of auditing in CodeReview.
    page.execute_script("$('#entry_end').trigger('onchange');")
    page.find_by_id('entry_duration_hours').value.should match "16:10"
  end

  it "deletes start and end time if duration gets modified", :js => true do
    fill_in "entry_start", :with => "06:05 AM" 
    fill_in "entry_end", :with => "10:15 PM" 
    fill_in "entry_duration_hours", :with => "1:0"
    page.find_by_id('entry_start').value.should match ""
    page.find_by_id('entry_end').value.should match ""
  end

  it "loads tasks for a project", :js => true do
    page.find('#entry_task_id option').has_select?("First task")
  end
  
  it "shows an alert if mandatory fields are left out", :js => true do
    click_button "Create Entry"
    page.should have_css("#flash_alert")
  end

  it "shows a friendly notice when an entry has been created", :js => true do
    create_new_entry
    page.should have_css("#flash_notice")
  end

  it "shows a friendly notice when an entry has been updated", :js => true do
    create_new_entry
    # Click edit link
    find(:xpath, "/html/body/div/table/tbody/tr[2]/td[5]/a").click()
    click_button "Update Entry"
    page.should have_css("#flash_notice")
  end
  
  it "confirms when an entry is deleted", :js => true do
    create_new_entry
    # Click delete button
    find(:xpath, "/html/body/div/table/tbody/tr[2]/td[6]/a").click()
    page.should have_css("#flash_notice")
  end
  
  it "displays entries from the associated day of the previously created entry",
    :js => true do
    # Chose the 9th of the current month
    find(:xpath, 
         "/html/body/div/form/div[2]/div/table/tbody/tr[2]/td[4]/a").click()
    select @project.shortname, :from => 'entry_project_id' 
    entry_duration = "3:0"
    create_new_entry(duration = entry_duration)
    page.should have_content entry_duration
  end

end
