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
  it "calculates the duration when given start and end time", :js => true do
    pending("it's working in the app, but not in this test")
    fill_in "entry_start", :with => "06:05 AM" 
    fill_in "entry_end", :with => "10:15 PM" 
    #page.execute_script("$('#entry_end').trigger('onchange');")
    page.find_by_id('entry_duration_hours').value.should match "16:10"
  end

  it "deletes start and end time if duration gets modified", :js => true do
    fill_in "entry_start", :with => "06:05 AM" 
    fill_in "entry_end", :with => "10:15 PM" 
    choose('time_capture_method_duration')
    fill_in "entry_duration_hours", :with => "1:0"
    page.find_by_id('entry_start').value.should match ""
    page.find_by_id('entry_end').value.should match ""
  end

  it "loads tasks for a project", :js => true do
    page.find('#entry_task_id option').has_select?("First task")
  end
  
  context 'displays entries from the associated day' do
    before(:each) do
      choose_9th_of_the_month
      select @project.shortname, :from => 'entry_project_id' 
      choose('time_capture_method_duration')
      @entry_duration = "3:0"
      create_new_entry(duration = @entry_duration)
    end

    it 'of the previously created entry', :js => true do
      page.should have_content @entry_duration
    end

    it 'of the previously updated entry', :js => true do
      # Click edit link
      find(:xpath, "/html/body/div/table/tbody/tr[2]/td[5]/a").click()
      page.should have_content @entry_duration
    end
  end

  it 'allows only one time entry method at a time', :js => true do
    choose('time_capture_method_start_end')
    find('#entry_duration_hours')['disabled'].should == 'true'
    choose('time_capture_method_duration')
    find('#entry_start')['disabled'].should == 'true'
    find('#entry_end')['disabled'].should == 'true'
  end

  it 'focuses the description field if task has been selected', :js => true do
    task = Factory(:task, :project_id => @project.id)
    select 'First task', :from => 'entry_task_id'
    find('#entry_task_id').click
    page.evaluate_script('document.activeElement.id').should eq('entry_description')
  end

  it 'focuses the description field after selecting a day in the calendar'
  it 'focuses the project or task field after selecting a day in the calendar'
end
