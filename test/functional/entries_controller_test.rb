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
    get :index, {}, { :user_id => users(:seb) } 
    assert_response :success
    assert_template 'entries/new.html.erb'
  end

  # when no projects are given, we should redirect to the projects view
  def test_list_no_projects
    Project.destroy_all
    get :index, {}, { :user_id => users(:seb) } 
    assert_redirected_to :controller => "projects"
    assert_equal "Please enter at least one project before adding entries.",
      flash[:notice] 
  end

  # test some fixtures used by these tests
  def test_fixtures
    assert_equal 1, Project.count(:all, :conditions => ['inactive = ?', false]) 
    assert_equal 3, users(:seb).entries.count
    assert_equal 2, Entry.count(:all,
      :conditions => ["date = '2007-05-28' AND user_id = #{users(:seb).id}"])
  end

  # simulate get from jscalendar with a date having entries for the current
  # user
  def test_list_on_date_with_entries
    get :index, {:y => 2007, :m => 4, :d => 28}, { :user_id => users(:seb).id }
    assert_equal 2, assigns['entries'].length
    assert_equal 4, assigns['total']
    assert_nil assigns['entry'].id # the new record
  end

  def test_edit
    get :edit, {:id => entries(:first)}, {:user_id => users(:seb).id}
    assert_response :success
    assert assigns(:entry)
  end

  # simulates an edit request by submitting an entry id
  def test_edit_on_date_with_entries
    get :edit, {:id => entries(:first), :y => 2007, :m => 4, :d => 28}, { :user_id => users(:seb).id }
    assert_equal 2, assigns['entries'].length
    assert_equal 4, assigns['total']
    assert_equal 'A complete entry', assigns['entry'].description
  end

  # simulates an edit request by submitting an entry id that does not
  # belong to current user
  def test_unauthorized_edit_request
    # this will end in an Template error because entry is empty in this case
    assert_raise ActiveRecord::RecordNotFound do
      get :edit, {:id => 1}, { :user_id => users(:dilbert).id }
    end
  end

    

  # test the destroy function as requested from the web
  def test_destroy
    entry_id = entries(:first).id
    post :destroy, {:id => entry_id}, { :user_id => users(:seb) }
    assert_raise ActiveRecord::RecordNotFound do
      Entry.find(entry_id)
    end
  end

  def test_destroy_not_authorized
    assert_raise ActiveRecord::RecordNotFound do
      post :destroy, {:id => entries(:first)}, { :user_id => users(:dilbert) } 
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
    assert_difference 'Entry.count' do
      post :create, { :entry => params }, { :user_id => users(:seb) }
    end
    e = Entry.last
    assert_equal users(:seb).id, e.user_id
    assert_equal 'test', e.description
    assert_equal key_date, e.date
    assert_redirected_to entries_url
  end

  def test_update_success
    e = entries(:first)
    e.duration = 123
    put :update, { :id => e.id, :entry => e.attributes }, { :user_id => users(:seb) }
    assert_redirected_to entries_url
    e.reload
    assert_equal 123, e.duration
  end

  def test_update_failure
    e = entries(:first)
    e.description = ''
    put :update, { :id => e.id, :entry => e.attributes }, { :user_id => users(:seb) }
    assert_response :success
    assert !assigns(:entry).errors.empty?
  end

  # tests the date parsing
  def test_date
    # when no params given, today is assumed
    get :index, {}, { :user_id => users(:seb) }
    assert_equal Date.today(), assigns(:date)
    assert_equal Date.today(), @controller.session[:date]
  end


end
