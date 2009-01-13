require File.dirname(__FILE__) + '/../test_helper'
require 'entries_controller'

# Re-raise errors caught by the controller.
class EntriesController; def rescue_action(e) raise e end; end

class EntriesControllerTest < Test::Unit::TestCase
  fixtures :entries, :users, :projects

  def setup
    @controller = EntriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_access_denied
    get :index
    assert_redirected_to :controller => "login", :action => "login"
    assert_equal "Please log in", flash[:notice] 
  end

  # tests access controll of index page
  def test_access_index
    get :index, {}, { :user_id => 1 } 
    assert_response :success
    assert_template 'entries/new.html.erb'
  end

  # when no projects are given, we should redirect to the projects view
  def test_list_no_projects
    Project.destroy_all
    get :index, {}, { :user_id => 1 } 
    assert_redirected_to :controller => "projects"
    assert_equal "Please enter at least one project before adding entries.",
      flash[:notice] 
  end

  # test some fixtures used by these tests
  def test_fixtures
    assert_equal 1, Project.count(:all, :conditions => ['inactive = ?', false]) 
    assert_equal 3, Entry.count(:all, :conditions => ['user_id = 1'])
    assert_equal 2, Entry.count(:all,
      :conditions => ['date = "2007-05-28" AND user_id = 1'])
  end

  # simulate get from jscalendar with a date having entries for the current
  # user
  def test_list_on_date_with_entries
    get :index, {:y => 2007, :m => 4, :d => 28}, { :user_id => 1 }
    assert_equal 2, assigns['entries'].length
    assert_equal 3.7, assigns['total']
    assert_nil assigns['entry'].id # the new record
  end

  # simulates an edit request by submitting an entry id
  def test_list_on_date_with_entries
    get :edit, {:id => 1, :y => 2007, :m => 4, :d => 28}, { :user_id => 1 }
    assert_equal 2, assigns['entries'].length
    assert_equal 4, assigns['total']
    assert_equal 1, assigns['entry'].id # the edit record
    assert_equal 'A complete entry', assigns['entry'].description
  end

  def test_edit
    get :edit, {:id => 1}, {:user_id => 1}
    assert_response :success
    assert assigns(:entry)
  end

  # simulates an edit request by submitting an entry id that does not
  # belong to current user
  def test_unauthorized_edit_request
    # this will end in an Template error because entry is empty in this case
    assert_raise ActiveRecord::RecordNotFound do
      get :edit, {:id => 1}, { :user_id => 2 }
    end
  end

    

  # test the destroy function as requested from the web
  def test_destroy
    assert_not_nil Entry.find(1)
    post :destroy, {:id => 1}, { :user_id => 1 }
    assert_raise ActiveRecord::RecordNotFound do
      Entry.find(1)
    end
  end

  def test_destroy_not_authorized
    assert_raise ActiveRecord::RecordNotFound do
      post :destroy, {:id => 1}, { :user_id => 2 } 
    end 
  end

  # tests the creation and upgrade of a record via the persist method
  def test_create_success
    key_date = Date.civil(2001,3,30) 
    params = {
      :id          => '',
      :project_id  => '1',
      :description => 'test',
      :duration    => '1.1',
      :date        => key_date.to_s
    }

    # test the create case
    post :create, { :entry => params }, { :user_id => 1 }
    e = Entry.last
    assert_equal 1, e.user_id
    assert_equal 'test', e.description
    assert_equal key_date, e.date
    assert_redirected_to entries_url
  end

  def test_update_success
    e = entries(:first)
    e.duration = 123
    put :update, { :id => e.id, :entry => e.attributes }, { :user_id => 1 }
    assert_redirected_to entries_url
    e.reload
    assert_equal 123, e.duration
  end

  def test_update_failure
    e = entries(:first)
    e.description = ''
    put :update, { :id => e.id, :entry => e.attributes }, { :user_id => 1 }
    assert_response :success
    assert !assigns(:entry).errors.empty?
  end



  # tests the date parsing
  def test_date
    # when no params given, today is assumed
    get :index, {}, { :user_id => 1 }
    assert_equal Date.today(), assigns(:date)
    assert_equal Date.today(), @controller.session[:date]
  end
#    # session in date is used when nothing else available
#    d = Date.civil(2004,3,30) 
#    @controller.session[:date] = d
#    assert_equal d, @controller.date    
#    assert_equal d, @controller.session[:date]
#    # the date can be submitted as parameters from the select_date fields
#    d = Date.civil(2004,3,01) 
#    @controller.params[:date] = { :year => d.year,
#      :month => d.month, :day => d.day }
#    assert_equal d, @controller.date    
#    assert_equal d, @controller.session[:date]
#  end




end
