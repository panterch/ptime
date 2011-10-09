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

    # Remove chosen JS to be able to fill in values
    #page.execute_script("$('#entry_project_id, #entry_task_id').removeAttr('style');")

    select @project.shortname, :from => 'entry_project_id'
  end

  after(:each) do
    log_out
  end

  it "calculates the duration when given start and end time", :js => true do
    fill_in "entry_start", :with => "06:05"
    fill_in "entry_end", :with => "22:15"
    page.execute_script("$('#entry_end').trigger('change');")
    page.find_by_id('entry_duration_hours').value.should match "16:10"
  end

  it "deletes start and end time if duration gets modified", :js => true do
    fill_in "entry_start", :with => "06:05"
    fill_in "entry_end", :with => "22:15"
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
      find(:xpath, "//table[@class='entries']/tbody/tr[1]/td[5]/a").click()
      page.should have_content @entry_duration
    end
  end

  it 'allows only one time entry method at a time', :js => true do
    choose('time_capture_method_duration')
    find('#entry_start')['disabled'].should == 'true'
    find('#entry_end')['disabled'].should == 'true'
    choose('time_capture_method_start_end')
    find('#entry_duration_hours')['disabled'].should == 'true'
  end

  it 'focuses the description field if task has been selected', :js => true do
    task = Factory(:task, :project_id => @project.id)
    select 'First task', :from => 'entry_task_id'
    find('#entry_task_id').click
    page.evaluate_script('document.activeElement.id').should eq('entry_description')
  end

  context 'invalid entry' do
    it 'fills duration input field with its submitted value' do
      choose 'time_capture_method_duration'
      fill_in "entry_duration_hours", :with => 'abc'
      click_button 'Create Entry'
      find_field('entry_duration_hours').value.should eq('abc')
    end
  end
end
