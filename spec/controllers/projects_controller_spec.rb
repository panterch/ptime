require 'spec_helper'

describe ProjectsController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user, :admin => true)
    sign_in @user
  end

  context 'GET on new' do
    before(:each) { get :new }
    it 'assigns a new project record' do
      assigns(:project).should be_a_new(Project)
    end
    it 'responds with success' do
      response.code.should eq('200')
    end
    it('creates a new project with default tasks') do
      assigns(:project).tasks.should_not be_empty
    end

  end
  
  context 'POST on create' do
    before(:each) do
       project_attributes = Factory.attributes_for(:project)
       project_state_attributes = Factory.attributes_for(:project_state)
       post :create, :project => project_attributes.merge(
        { :project_state_attributes => project_state_attributes })
    end
    it('responds with a redirect') { response.code.should eq('302') }
    it('creates a new project') { assigns(:project).should_not be_a_new_record }
  end

  context 'POST on create with project with associated task' do
    before(:each) do
      @project = Factory.attributes_for(:project).merge(
          { :tasks_attributes => [{:name => "First task", :inactive => false }],
            :project_state_attributes => { :name => "Test state" }})
      post :create, :project => @project
    end
    it('responds with a redirect') { response.code.should eq('302') }
    it('creates a new project') { assigns(:project).should_not be_a_new_record }
    it('creates a new project with associated task') do
      Project.find_by_shortname(@project[:shortname]).tasks.should_not be_empty
    end
  end

  context 'Find existing project' do
    before(:each) do
      @project = Factory(:project, :shortname => "xyz-987", 
                         :description => "project_1")
    end

    context 'GET on edit' do
      before(:each) { get :edit, :id => @project.id }
      it('responds with success') { response.code.should eq('200') }
    end

    context 'GET on index' do
      it('responds with success') do
        get :index
        response.code.should eq('200')
      end
      it('assigns projects') do
        get :index
        assigns(:projects).should eq([@project])
      end

      describe 'sort projects table' do

        it 'sorts by id asc by default' do
          get :index
          assigns(:projects).first.shortname.should eq(@project.shortname)
        end
        it 'sorts by shortname desc when asked to' do
          project_2 = Factory(:project, :shortname => "zyx-555", 
                             :description => "project_2")
          get :index, { :direction => 'desc', :sort => 'shortname' }
          assigns(:projects).first.shortname.should eq(project_2.shortname)
        end
        it 'sorts by description asc when asked to' do
          get :index, { :direction => 'asc', :sort => 'description' }
          assigns(:projects).first.description.should eq(@project.description)
        end
        it 'sorts by description desc when asked to' do
          project_2 = Factory(:project, :shortname => "dfb-123", 
                             :description => "project_2")
          get :index, { :direction => 'desc', :sort => 'description' }
          assigns(:projects).first.description.should eq(project_2.description)
        end
      end
    end
  end

end
