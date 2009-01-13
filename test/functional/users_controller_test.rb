require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

  # asserts the fixtures for this test were loaded
  def test_fixture
    assert User.find_by_name('seb')
    assert User.find_by_name('seb').admin?
    assert_equal 2, User.count()
  end

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
    get :index, {}, { :user_id => users(:seb).id } 
    assert_response 200
    assert_template 'users/user'

    assert_not_nil assigns(:users)
    assert_not_nil assigns(:user)
    assert_nil assigns(:user).id
  end

  # tests the creation and upgrade of a record via the persist method
  def test_persist
    params = {
      :name => 'mama',
      :password => 'test',
      :password_confirmation => 'test',
      :inactive => 'false'
    }

    # test the create case
    assert_difference 'User.count' do
      post :create, { :user => params }, { :user_id => users(:seb).id } 
    end
    assert_redirected_to users_path
    u = User.find_by_name('mama')
    assert_not_nil u
    assert !u.inactive?

    # update case
    params[:id] = u.id.to_s
    params[:name] = 'mama_mia'
    post :update, { :id => params[:id], :user => params }, { :user_id => users(:seb).id }
    assert_redirected_to users_path
    u = User.find(u.id)
    assert_equal 'mama_mia', u.name

  end

end
