require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Report for entries', %q{
  In order to review the time employees spent on projects
  When I am logged in
  I want to have access to a CSV report
} do

  scenario 'a CSV line consists required columns' do
    pending
    entry = Factory(:entry, :day => Time.now)
    log_in
    visit '/report.csv'
    # Matching entry, ignoring date due to format differences
    csv_line_part_one = [entry.project.shortname,
      entry.user.username].join(',')
    csv_line_part_two = [entry.duration_hours, entry.task.name,
      entry.description, entry.billable].join(',')
    page.should have_content(csv_line_part_one)
    page.should have_content(csv_line_part_two)
  end
end
