require File.dirname(__FILE__) + '/../test_helper'

class BillsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:bills)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_bill
    assert_difference('Bill.count') do
      post :create, :bill => { }
    end

    assert_redirected_to bill_path(assigns(:bill))
  end

  def test_should_show_bill
    get :show, :id => bills(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => bills(:one).id
    assert_response :success
  end

  def test_should_update_bill
    put :update, :id => bills(:one).id, :bill => { }
    assert_redirected_to bill_path(assigns(:bill))
  end

  def test_should_destroy_bill
    assert_difference('Bill.count', -1) do
      delete :destroy, :id => bills(:one).id
    end

    assert_redirected_to bills_path
  end
end
