require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Authentication via devise", %q{
  In order to have a secure application
  When I am logged in
  I want to have access to the application
  When I am not logged in
  I want to be prompted with the log in form
} do

  scenario "cannot access the application without login" do
    visit '/'
    current_path.should match new_user_session_path
  end

  scenario "cannot access the application after logout" do
    log_in
    log_out
    visit '/'
    current_path.should match new_user_session_path
  end

  scenario "can access the application with valid login" do
    log_in
    visit '/'
    current_path.should match '/'
  end

  scenario "cannot access the application with invalid login" do
    visit "/"
    user = Factory.create(:user)
    fill_in "user_username", :with => user.username
    fill_in "user_password", :with => "wrong_password"
    click_button "Sign in"
    visit '/'
    current_path.should match new_user_session_path
  end

end
