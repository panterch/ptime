require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Posts Page", %q{
  In order to have many posts
  When I am logged in
  I want to start creating a post first
} do

  scenario "should create new post" do
    log_in
    post = Factory.build(:post)
    visit '/posts/new'

    fill_in 'post_title', :with => post.title
    fill_in 'post_body', :with => post.body
    click_button 'Create Post'

    current_path.should match %r{/posts/\d+}
    page.should have_content(post.title) if post.title
    page.should have_content(post.body) if post.body
  end

  scenario "should show post index" do
    log_in
    attributes = Factory.attributes_for(:post)
    Post.create!(attributes)

    visit posts_url
    values = attributes.collect{|k,v| v}
    values.each do |value|
      page.should have_content(value)
    end
  end

  scenario "should not be able to create new post without login" do
    visit '/posts/new'
    current_path.should match new_user_session_path
    page.should have_content('Forgot your password?')
  end

  scenario "should not be able to create new post after logout" do
    log_in
    log_out
    visit '/posts/new'
    current_path.should match new_user_session_path
    page.should have_content('Forgot your password?')
  end
end
