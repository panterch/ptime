require File.dirname(__FILE__) + '/../test_helper'
require 'login_controller'

# Re-raise errors caught by the controller.
class LoginController; def rescue_action(e) raise e end; end


class LoginControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = LoginController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # asserts the fixtures for this test were loaded
  def test_fixture
    assert User.find(1)
    assert_equal 2, User.count()
  end

  def test_login
    post :login, {:name => 'seb', :password => 'test'}, {} 
    assert_equal 1, session[:user_id]
    assert_redirected_to :controller => 'entries'
  end

  def test_login_invalid
    post :login, {:name => 'seb', :password => 'invalid'}, {} 
    assert_nil session[:user_id]
    assert_template 'login/login'
  end

  def test_logout
    get :logout, {}, { :user_id => '1' } 
    assert_nil session[:user_id]
    assert_redirected_to :action => 'login'
  end

  def test_access_not_logged_in
    get :index
    assert_redirected_to :action => "login"
    assert_equal "Please log in", flash[:notice] 
  end

  def test_access_user_unknown
    get :index, {}, { :user_id => 123 } 
    assert_redirected_to :action => "login"
    assert_equal "Please log in", flash[:notice] 
  end

  def test_access_granted
    get :index, {}, { :user_id => 1 } 
    assert_response 200
    assert_template 'index'

    assert_not_nil assigns(:users)
    # an empty project should be listed
    assert_not_nil assigns(:user)
    assert_nil assigns(:user).id
  end

  def test_edit
    get :index, { :id => 1 }, { :user_id => 1 } 

    assert_response :success
    assert_template 'index'

    assert_equal   1, assigns(:user).id
    assert_equal   'seb', assigns(:user).name
  end

  # this tests the special case when no users are in database:
  # the first user must be inserted with the add_user action
  def test_access_no_users
    User.delete_all
    assert_equal 0, User.count()
    # requests to any page should be redirected
    get :controller => :entry
    assert_redirected_to :action => "index", :controller => 'login'
    assert_equal "Please add initial user", flash[:notice] 
    assert session[:setup]
    # requests to index should be allowed
    get :index
    assert_response 200
  end

  # tests the creation and upgrade of a record via the persist method
  def test_persist
    params = {
      :id   => '',
      :name => 'mama',
      :password => 'test',
      :password_confirmation => 'test',
      :inactive => 'false'
    }

    # test the create case
    post :persist, { :user => params }, { :user_id => 1 } 
    assert_template 'login/index'
    u = User.find_by_name('mama')
    assert_not_nil u
    assert !u.inactive?

    # update case
    params[:id] = u.id.to_s
    params[:name] = 'mama_mia'
    get :persist, { :user => params }, { :user_id => 1 }
    assert_template 'login/index'
    u = User.find(u.id)
    assert_equal 'mama_mia', u.name

  end

  # when the first user is created, you should be redirected to login
  def test_persist_setup

    User.destroy_all

    params = {
      :id   => '',
      :name => 'mama',
      :password => 'test',
      :password_confirmation => 'test',
      :inactive => 'false'
    }

    # test the create case
    post :persist, { :user => params }, { :setup => true } 
    assert_not_nil User.find_by_name('mama')
    assert_redirected_to :controller => 'login', :action => 'login'
    assert !session[:setup]

  end

end
  
