require 'spec_helper'

describe ReportsController do
  include Devise::TestHelpers

  before (:each) do
    task = Factory(:task)
    @user = Factory(:user, :admin => false)
    project = Factory(:project)
    @entry = Factory(:entry, :duration_hours => "2:00")
    sign_in @user
    Timecop.freeze(@entry.day)
  end

  after (:each) { Timecop.return }

  context 'POST on show with allowed and forbidden user time entries' do
    before(:each) do
      user_2 = Factory(:user, :username => "test_user2")
      @entry_2 = Factory(:entry, :user => user_2)
    end
    it 'renders entries when only searching for own time entries' do
      post :show, :search => { :user_id_equals => (@entry.user.id).to_s }
      assigns(:report).relation.should_not be_empty 
    end
    pending 'does returns 403 when asking for other peoples time entries' do
      post :show, :search => { :user_id_equals => (@entry_2.user.id).to_s }
      response.response_code.should == 403
    end
  end

  context 'POST on show to sort the reports table' do
    before(:each) do
      user_2 = Factory(:user, :username => "test_user2")
      @entry_2 = Factory(:entry, :user => user_2)
    end

    it 'renders entries sorted by user asc if asked to' do
      post :show, :search => { :meta_sort  => 'user_id.asc' }
      assigns(:report).relation.entries.first.user.username.should \
        eq(@entry.user.username)
    end
    it 'renders entries sorted by user desc if asked to' do
      post :show, :search => { :meta_sort  => 'user_id.desc' }
      assigns(:report).relation.entries.first.user.username.should \
        eq(@entry_2.user.username)
    end
  end

  context 'POST on new with too constraining searches on time' do
    render_views
    before(:each) do
      post :show, :search => {
        "day_gte(1i)" => (@entry.day + 1.year).to_s,
        "day_lte(1i)" => (@entry.day + 1.year).to_s
      }
    end

    it 'does not render entries' do
      response.body.should_not =~ /#{@entry.task.name}/m
    end
    it 'assigns an empty meta_search report' do
      assigns(:report).relation.should be_empty
    end
    it 'assigns a total_time for entries of 0:00 hours' do
      assigns(:total_time).should eq("0:00")
    end
  end

  context 'POST on new with constraining searches on time' do
    render_views

    it 'renders entries that are in the constraining timeframe' do
      post :show, :search => { 
        "day_gte(1i)" => (@entry.day - 1.year).to_s,
        "day_lte(1i)" => (@entry.day + 1.year).to_s
      }
      response.body.should =~ /#{@entry.task.name}/m
    end
    it 'does not render entries for unrelated projects' do
      post :show, :search => { 
        :project_id_equals => (@entry.project.id + 1).to_s 
      }
      response.body.should_not =~ /#{@entry.task.name}/m
    end
  end

  context 'POST on show with constraining searches on projects' do
    render_views
    before(:each) do
      task = Factory(:task, :name => "test_task")
      project = Factory(:project, :shortname => "def-456")
      @second_entry = Factory(:entry, :project => project, :task => task)
      post :show, :search => { :user_id_equals => (@entry.user.id).to_s }
    end

    it 'renders entries for related projects' do
      response.body.should =~ /#{@entry.task.name}/m
    end
    it 'does not renders entries for unrelated projects' do
      response.body.should_not =~ /#{@second_entry.task.name}/m
    end
  end

  context 'POST on show with constraining searches on users' do
    render_views
    before(:each) do
      user = Factory(:user, :username => "test_user")
      task = Factory(:task, :name => "test_task")
      @second_entry = Factory(:entry, :user => user, :task => task)
      post :show, :search => { :user_id_equals => (@entry.user.id).to_s }
    end

    it 'renders entries for related users' do
      response.body.should =~ /#{@entry.task.name}/m
    end
    it 'does not renders entries for unrelated users' do
      response.body.should_not =~ /#{@second_entry.task.name}/m
    end
  end

  context 'POST on show without constraining search' do
    render_views
    before(:each) { post :show }

    it 'renders entries' do
      response.body.should =~ /#{@entry.task.name}/
    end
    it 'responds with success' do
      response.code.should eq('200')
    end
    it 'assigns a new meta_search report' do
      assigns(:report).class.should eq(MetaSearch::Searches::Entry)
    end
    it 'assigns a new non empty meta_search report' do
      assigns(:report).relation.should_not be_empty
    end
    it 'assigns paginated entries' do
      assigns(:entries).class.should eq(WillPaginate::Collection)
    end
    it 'assigns a total_time for entries of 2:00 hours' do
      assigns(:total_time).should eq("2:00")
    end
  end


end
