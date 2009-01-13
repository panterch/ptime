require File.dirname(__FILE__) + '/../test_helper'
require 'login_controller'

# Re-raise errors caught by the controller.
class LoginController; def rescue_action(e) raise e end; end


class LoginControllerTest < Test::Unit::TestCase

  def setup
    @controller = LoginController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end


  def test_login
    post :login, {:name => 'seb', :password => 'test'}, {} 
    assert_equal users(:seb).id, session[:user_id]
    assert_redirected_to :controller => 'entries'
  end

  def test_login_invalid
    post :login, {:name => 'seb', :password => 'invalid'}, {} 
    assert_nil session[:user_id]
    assert_template 'login/login'
  end

  def test_logout
    get :logout, {}, { :user_id => users(:seb).id } 
    assert_nil session[:user_id]
    assert_redirected_to :action => 'login'
  end


end
  
