require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Report for entries", %q{
  In order to review the time employees spent on projects
  When I am logged in
  I want to have access to a csv report
} do

  scenario "csv line consists of project name, username, day, duration and task" do
    entry = Factory(:entry)
    log_in
    visit "/report/new.csv"
    csv_line = [entry.project.shortname, entry.user.username, entry.day.to_s,
      entry.duration_hours, entry.task.name].join(',')
    page.should have_content(csv_line)
  end
end
