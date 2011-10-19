require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Edit user as admin and as user", %q{
  When i am a admin i can edit all users.
  When i am not a admin i can show and edit only my user and i need to input
    my password as confirmation.
} do

  scenario 'edit another user as admin'

  scenario "edit email-address as admin without enter any password" do
    log_in :admin=>true
    visit '/'
    click_link 'edit_current_user'
    page.should have_css 'form.user'
    fill_in 'user[email]', :with=>'nobody2@example.com'
    click_button 'Update User'
    page.should_not have_css '.inline-errors'
  end
  scenario "edit password as admin with correct current_password" do
    log_in :admin=>true
    visit '/'
    click_link 'edit_current_user'
    page.should have_css 'form.user'
    fill_in 'user[password]', :with=>'goodbye'
    fill_in 'user[current_password]', :with=>'good_password'
    click_button 'Update User'
    page.should_not have_css '.inline-errors'
  end
  scenario "edit password as admin with wrong current_password" do
    log_in :admin=>true
    visit '/'
    click_link 'edit_current_user'
    page.should have_css 'form.user'
    fill_in 'user[password]', :with=>'goodbye'
    fill_in 'user[current_password]', :with=>'not_good_password'
    click_button 'Update User'
    page.should have_css '.inline-errors'
  end

  scenario "edit external flag as admin" do
    # Given
    user = Factory.create(:user, :username => 'freelancer')
    log_in :admin => true

    # When
    visit '/'
    click_link 'Users'
    within "#user_#{user.id}" do
      click_link "Edit"
    end
    check 'External'
    click_button "Update User"

    within "#user_#{user.id}" do
      click_link "Edit"
    end

    # Then
    find('#user_external')["checked"].should == true
  end

  scenario "edit active flag as admin" do
    # Given
    user = Factory.create(:user, :username => 'john_doe')
    log_in :admin => true

    # When
    visit '/'
    click_link 'Users'
    within "#user_#{user.id}" do
      click_link "Edit"
    end
    check 'Active'
    click_button "Update User"

    within "#user_#{user.id}" do
      click_link "Edit"
    end

    # Then
    find('#user_active')["checked"].should == true
  end


  scenario "edit email-address as normal user" do
    log_in
    visit '/'
    click_link 'edit_current_user'
    page.should have_css 'form.user'
    fill_in 'user[email]', :with=>'nobody2@example.com'
    click_button 'Update User'
    page.should_not have_css '.inline-errors'
  end
  scenario "edit password as normal user with success" do
    log_in
    visit '/'
    click_link 'edit_current_user'
    page.should have_css 'form.user'
    fill_in 'user[password]', :with=>'goodbye'
    fill_in 'user[password_confirmation]', :with=>'goodbye'
    fill_in 'user[current_password]', :with=>'good_password'
    click_button 'Update User'
    page.should_not have_css '.inline-errors'
  end
  scenario "edit password as normal user with wrong current password" do
    log_in
    visit '/'
    click_link 'edit_current_user'
    page.should have_css 'form.user'
    fill_in 'user[password]', :with=>'goodbye'
    fill_in 'user[password_confirmation]', :with=>'goodbye'
    fill_in 'user[current_password]', :with=>'Not_good_password'
    click_button 'Update User'
    page.should have_css '.inline-errors'
  end
  scenario "edit password as normal user with wrong confirmation" do
    log_in
    visit '/'
    click_link 'edit_current_user'
    page.should have_css 'form.user'
    fill_in 'user[password]', :with=>'goodbye1'
    fill_in 'user[password_confirmation]', :with=>'goodbye2'
    fill_in 'user[current_password]', :with=>'good_password'
    click_button 'Update User'
    page.should have_css '.inline-errors'
  end
end
