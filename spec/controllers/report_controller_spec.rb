require 'spec_helper'

describe ReportController do
  include Devise::TestHelpers

  before (:each) do
    task = Factory(:task)
    @user = Factory(:user)
    project = Factory(:project)
    @entry = Factory(:entry)
    sign_in @user
    Timecop.freeze(@entry.day)
  end

  after (:each) { Timecop.return }

  context 'POST on index with constraining searches on time' do
    render_views

    it 'does not render entries with a search beyond the entries timeframe' do
      post :index, :report => {
        "day_gte(1i)" => (@entry.day + 1.year).to_s,
        "day_lte(1i)" => (@entry.day + 1.year).to_s
      }
      response.body.should_not =~ /#{@entry.task.name}/m
    end
    it 'renders entries that are in the constraining timeframe' do
      post :index, :report => { 
        "day_gte(1i)" => (@entry.day - 1.year).to_s,
        "day_lte(1i)" => (@entry.day + 1.year).to_s
      }
      response.body.should =~ /#{@entry.task.name}/m
    end
    it 'does not render entries for unrelated projects' do
      post :index, :report => { 
        :project_id_equals => (@entry.project.id + 1).to_s 
      }
      response.body.should_not =~ /#{@entry.task.name}/m
    end
  end

  context 'POST on index with constraining searches on projects' do
    render_views
    before(:each) do
      task = Factory(:task, :name => "test_task")
      project = Factory(:project, :shortname => "test_project")
      @second_entry = Factory(:entry, :project => project, :task => task)
      post :index, :report => { :user_id_equals => (@entry.user.id).to_s }
    end

    it 'renders entries for related projects' do
      response.body.should =~ /#{@entry.task.name}/m
    end
    it 'does not renders entries for unrelated projects' do
      response.body.should_not =~ /#{@second_entry.task.name}/m
    end
  end

  context 'POST on index with constraining searches on users' do
    render_views
    before(:each) do
      user = Factory(:user, :username => "test_user")
      task = Factory(:task, :name => "test_task")
      @second_entry = Factory(:entry, :user => user, :task => task)
      post :index, :report => { :user_id_equals => (@entry.user.id).to_s }
    end

    it 'renders entries for related users' do
      response.body.should =~ /#{@entry.task.name}/m
    end
    it 'does not renders entries for unrelated users' do
      response.body.should_not =~ /#{@second_entry.task.name}/m
    end
  end

  context 'POST on index without constraining search' do
    render_views
    before(:each) { post :index }

    it 'renders entries' do
      response.body.should =~ /#{@entry.task.name}/m
    end
    it 'responds with success' do
      response.code.should eq('200')
    end
    it 'assigns a new meta_search report' do
      assigns(:report).class.should eq(MetaSearch::Searches::Entry)
    end
    it 'assigns paginated entries' do
      assigns(:entries).class.should eq(WillPaginate::Collection)
    end
  end

end
