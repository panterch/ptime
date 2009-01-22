require 'test_helper'

class JavascriptsControllerTest < ActionController::TestCase

  def test_dynamic_tasks
    get :dynamic_tasks, {:format => :js}, { :user_id => users(:seb).id }
    assert_response :success
    assert !assigns(:tasks_by_project).empty?
  end


end
