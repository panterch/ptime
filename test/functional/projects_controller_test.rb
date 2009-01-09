require File.dirname(__FILE__) + '/../test_helper'
require 'projects_controller'

# Re-raise errors caught by the controller.
class ProjectsController; def rescue_action(e) raise e end; end

class ProjectsControllerTest < Test::Unit::TestCase
  fixtures :projects, :users

  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_access_denied
    get :index
    assert_redirected_to :controller => "login", :action => "login"
    assert_equal "Please log in", flash[:notice] 
  end

  def test_list
    get :index, {}, { :user_id => 1 } 

    assert_response :success
    assert_template 'index'

    assert_not_nil assigns(:projects)
    # an empty project should be listed
    assert_not_nil assigns(:project)
    assert_nil assigns(:project).id
  end

  def test_edit
    get :index, { :id => 1 }, { :user_id => 1 } 

    assert_response :success
    assert_template 'index'

    assert_not_nil assigns(:projects)
    assert_not_nil assigns(:project)
    assert_equal   1, assigns(:project).id
    assert_equal   'Test', assigns(:project).description
  end

  # tests the creation and upgrade of a record via the persist method
  def test_persist
    params = {
      :project => {
        :id          => '',
        :description => 'from functional test'
      }
    }
    # add two tasks
    params[:task] = { 0 => { :id => 0, :name => 'new task 1' }, 
                      1 => { :id => 1, :name => 'new task 2' } }

    # test the create case
    get :persist, params, { :user_id => 1 } 
    p = Project.find_by_description('from functional test')
    assert_not_nil p
    assert_equal 2, p.tasks.length
    assert p.tasks[0].name =~ /new task/
    assert p.tasks[1].name =~ /new task/

    # update case
    params[:project][:id] = p.id.to_s
    params[:project][:description] = 'updated!'
    taskId = p.tasks[0].id
    # simulate update of a task too
    params[:task] = { taskId => { :id => taskId, :name => 'updated task' } }
    get :persist, params, { :user_id => 1 }
    p = Project.find(p.id)
    assert_equal 'updated!', p.description
    assert_equal 'updated task', p.tasks[0].name

  end

  def test_new_project
    p = @controller.new_project
    assert_nil p.id
    assert p.tasks.length > 1
    p.tasks.each do |t|
      assert_not_nil t.id
      assert t == p.tasks[t.id]
    end
  end




end
