def log_in(options={})
  user = Factory.create(:user, options)
  visit "/"
  fill_in "user_username", :with => user.username
  fill_in "user_password", :with => user.password
  click_button "Sign in"
end

def log_out
  visit "/"
  click_link "(logout)"
end

def create_new_entry(duration = "1:0")
  fill_in "entry_duration_hours", :with => duration
  click_button "Create Entry"
end

def choose_9th_of_the_month
  find(:xpath, "(//td/a[@class='ui-state-default'])[9]").click()
end
