require 'spec_helper'

describe EntriesController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user)
    sign_in @user
  end

  context 'GET on new' do
    before(:each) { get :new }
    it 'assigns a new entry record' do
      assigns(:entry).should be_a_new(Entry)
    end
    it 'responds with success' do
      response.code.should eq('200')
    end
  end
  
  context 'POST on create with entry with associations' do
    before(:each) do 
      user = Factory(:user)
      project = Factory(:project)
      task = Factory(:task)
      @entry = Factory.attributes_for(:entry)
      post :create, :entry => @entry.merge( { :task_id => task.id, 
                                           :project_id => project.id } )
    end
    it('responds with a redirect') { response.code.should eq('302') }
    it('creates a new entry') { assigns(:entry).should_not be_a_new_record }
    it 'creates a new entry with associated project' do
      Entry.first.project.should_not be_nil
    end
    it 'creates a new entry with associated task' do
      Entry.first.task.should_not be_nil
    end
    it 'creates a new entry with associated user' do
      Entry.first.user.should_not be_nil
    end
    it 'displays a positive flash message with a valid request' do
      request.flash.try(:notice).should_not be_nil
    end
  end

  context 'POST on create with entry without associations' do
    before(:each) do
      user = Factory(:user)
      @project = Factory(:project)
      @task = Factory(:task)
      @entry = Factory.attributes_for(:entry)
    end
    it 'does not create a new entry without an associated project' do
      post :create, :entry => @entry.merge( { :task_id => @task.id } )
      Entry.first.should be_nil
    end
    it 'does not create a new entry without an associated task' do
      post :create, :entry => @entry.merge( { :project_id => @project.id } )
      Entry.first.should be_nil
    end
    it 'does not create a new entry without associated duration' do
      @entry.delete(:duration_hours)
      post :create, :entry => @entry.merge( { :task_id => @task.id, 
                                           :project_id => @project.id } )
      Entry.first.should be_nil
    end
    it 'does not create a new entry without associated day' do
      @entry.delete(:day)
      post :create, :entry => @entry.merge( { :task_id => @task.id, 
                                           :project_id => @project.id } )
      Entry.first.should be_nil
    end
    it 'does not create a new entry with invalid day format' do
      @entry[:day] = "a:2"
      post :create, :entry => @entry.merge( { :task_id => @task.id, 
                                           :project_id => @project.id } )
      Entry.first.should be_nil
    end
    it 'displays a negative flash message with missing associations' do
      post :create, :entry => @entry.merge( { :task_id => @task.id } )
      request.flash.try(:alert).should_not be_nil
    end
  end

end
