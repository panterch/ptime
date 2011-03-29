def log_in(options={})
  user = Factory.create(:user, options)
  visit "/"
  fill_in "user_username", :with => user.username
  fill_in "user_password", :with => user.password
  click_button "Sign in"
end

def log_out
  visit "/"
  click_link "Log out"
end

def create_new_entry(duration = "1:0")
  fill_in "entry_duration_hours", :with => duration
  click_button "Create Entry"
end

def choose_9th_of_the_month
  find(:xpath, 
       "/html/body/div/form/div[2]/div/table/tbody/tr[2]/td[4]/a").click()
end
