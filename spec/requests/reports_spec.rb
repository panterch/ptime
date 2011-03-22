require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Authentication via devise", %q{
  In order to review the time employees spent on projects
  When I am logged in
  I want to have access to a csv report
} do

  scenario "access csv export" do
    entry = Factory(:entry)
    log_in
    visit "/report.csv"
    page.should have_content(entry.day.to_s)
    page.should have_content(entry.task.name)
  end
end
