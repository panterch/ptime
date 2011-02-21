module HelperMethods
  def log_in
    user = Factory.create(:user)
    visit "/"
    fill_in "user_username", :with => user.username
    fill_in "user_password", :with => user.password
    click_button "Sign in"
  end

  def log_out
    visit "/"
    click_link "Log out"
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
