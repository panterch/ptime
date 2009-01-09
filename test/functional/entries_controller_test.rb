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
    assert_template 'index'
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
    get :index, {:id => 1, :y => 2007, :m => 4, :d => 28}, { :user_id => 1 }
    assert_equal 2, assigns['entries'].length
    assert_equal 4, assigns['total']
    assert_equal 1, assigns['entry'].id # the edit record
    assert_equal 'A complete entry', assigns['entry'].description
  end

  # simulates an edit request by submitting an entry id that does not
  # belong to current user
  def test_unauthorized_edit_request
    # this will end in an Template error because entry is empty in this case
    assert_raise ActiveRecord::RecordNotFound do
      get :index, {:id => 1, :y => 2007, :m => 4, :d => 28}, { :user_id => 2 }
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
    assert_raise NoMethodError do
      post :destroy, {:id => 1}, { :user_id => 2 } 
    end 
  end

  # tests the creation and upgrade of a record via the persist method
  def test_persist
    key_date = Date.civil(2001,3,30) 
    params = {
      :id          => '',
      :project_id  => '1',
      :description => 'test',
      :duration    => '1.1',
      :date        => key_date.to_s
    }

    # test the create case
    get :persist, { :entry => params }, { :user_id => 1 }
    e = Entry.find_by_date(key_date)
    assert_equal 1, e.user_id
    assert_equal 'test', e.description

    # update case
    params[:id] = e.id.to_s
    params[:duration] = '1.5'
    get :persist, { :entry => params }, { :user_id => 1 }
    e = Entry.find_by_date(key_date)
    assert_equal 1.5, e.duration

  end

  # tests the date parsing
  def test_date
    @controller.params = {}
    @controller.session = {}
    # when no params given, today is assumed
    assert_equal Date.today(), @controller.date    
    assert_equal Date.today(), @controller.session[:date]
    # session in date is used when nothing else available
    test_date = Date.civil(2004,3,30) 
    @controller.session[:date] = test_date
    assert_equal test_date, @controller.date    
    assert_equal test_date, @controller.session[:date]
    # the date can be submitted as parameters from the select_date fields
    test_date = Date.civil(2004,3,01) 
    @controller.params[:date] = { :year => test_date.year,
      :month => test_date.month, :day => test_date.day }
    assert_equal test_date, @controller.date    
    assert_equal test_date, @controller.session[:date]
  end




end
