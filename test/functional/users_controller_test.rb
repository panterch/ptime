require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

  def test_access_not_logged_in
    get :index
    assert_redirected_to :action => "login"
    assert_equal "Please log in", flash[:notice] 
  end

  def test_access_user_unknown
    assert_raise ActiveRecord::RecordNotFound do
      get :index, {}, { :user_id => 123 } 
    end
  end

  def test_access_granted
    get :edit, {}, { :user_id => users(:seb).id } 
    assert_response 200
    assert_template 'users/edit.html.haml'

    assert_not_nil assigns(:user)
    assert_equal assigns(:user).id, users(:seb).id
  end

end
