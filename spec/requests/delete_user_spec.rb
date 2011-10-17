require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Delete user as admin", %q{
  In order to delete users
  As an admin
  I want to be able mark users inactive
} do

  before(:each) do
    # Create some users
    1.upto(4) do |number|
      Factory.create(:user, :username => "user#{number}")
    end

    # We'll use the second user for testing
    @user2 = User.where(:username => 'user2').first

    log_in :admin => true
  end

  scenario "delete user" do
    visit '/'
    click_link 'Users'
    within "#user_#{@user2.id}" do
      click_link "Delete"
    end

    page.should_not have_content "user2"
  end

end
