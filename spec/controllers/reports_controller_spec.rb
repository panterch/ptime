require 'spec_helper'

describe ReportsController do
  include Devise::TestHelpers

  before (:each) do
    task = Factory(:task)
    @user = Factory(:user)
    project = Factory(:project)
    @entry = Factory(:entry, :duration_hours => "2:0")
    sign_in @user
    Timecop.freeze(@entry.day)
  end

  after (:each) { Timecop.return }

  context 'POST on new with too constraining searches on time' do
    render_views
    before(:each) do
      post :show, :report => {
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
    it 'assigns a total_time for entries of 0:0 hours' do
      assigns(:total_time).should eq("0:0")
    end
  end

  context 'POST on new with constraining searches on time' do
    render_views

    it 'renders entries that are in the constraining timeframe' do
      post :show, :report => { 
        "day_gte(1i)" => (@entry.day - 1.year).to_s,
        "day_lte(1i)" => (@entry.day + 1.year).to_s
      }
      response.body.should =~ /#{@entry.task.name}/m
    end
    it 'does not render entries for unrelated projects' do
      post :show, :report => { 
        :project_id_equals => (@entry.project.id + 1).to_s 
      }
      response.body.should_not =~ /#{@entry.task.name}/m
    end
  end

  context 'POST on show with constraining searches on projects' do
    render_views
    before(:each) do
      task = Factory(:task, :name => "test_task")
      project = Factory(:project, :shortname => "test_project")
      @second_entry = Factory(:entry, :project => project, :task => task)
      post :show, :report => { :user_id_equals => (@entry.user.id).to_s }
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
      post :show, :report => { :user_id_equals => (@entry.user.id).to_s }
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
      response.body.should =~ /#{@entry.task.name}/m
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
    it 'assigns a total_time for entries of 2:0 hours' do
      assigns(:total_time).should eq("2:0")
    end
  end

end
