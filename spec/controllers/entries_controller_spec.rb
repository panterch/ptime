require 'spec_helper'

describe EntriesController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user)
    sign_in @user
  end

  context 'PUT update with valid attributes' do
    before(:each) do
      @entry_attributes = Factory.attributes_for(:entry)
      @entry = Factory(:entry, :user => @user)
    end

    it "redirects to the new entry form with the entry's :day parameter" do
      put :update, :id => @entry.id, :entry => @entry_attributes
      response.should redirect_to(new_entry_path + "?day=" + \
                                  @entry.day.strftime("%Y-%m-%d"))
    end
    it "updates the entry's attributes" do
      put :update, :id => @entry.id, :entry => @entry_attributes
      request.flash.try(:notice).should eq "Successfully updated entry."
    end
  end

  context 'PUT update with invalid attributes' do
    it "doesn't update the entry's attributes" do
      @entry_attributes = Factory.attributes_for(:entry)
      @entry_attributes[:day] = ''
      @entry = Factory(:entry, :user => @user)
      put :update, :id => @entry.id, :entry => @entry_attributes
      assigns(:entry).errors.should_not be_empty
    end
  end

  context 'DELETE destroy with correct user' do
    before(:each) do
      @entry_attributes = Factory.attributes_for(:entry)
      @entry = Factory(:entry, :user => @user)
    end
    it "destroys the entry" do
      delete :destroy, :id => @entry.id
      request.flash.try(:notice).should eq "Successfully destroyed entry."
    end
    it "redirects to the new entry form with the entry's :day parameter" do
      delete :destroy, :id => @entry.id
      response.should redirect_to(new_entry_url + "?day=" + \
                                  @entry.day.strftime("%Y-%m-%d"))
    end
  end

  context 'DELETE destroy with incorrect user' do
    before(:each) do
      @entry_attributes = Factory.attributes_for(:entry)
      user = Factory(:user, :username => "bad_guy")
      @entry = Factory(:entry, :user => user)
    end
    it "doesn't destroy entries from other users" do
      delete :destroy, :id => @entry.id
      @entry.should == Entry.find(@entry.id)
    end
    it "redirects when sb. tries to delete other users' entries" do
      delete :destroy, :id => @entry.id
      response.code.should eq('404')
    end
  end

  context 'GET on new' do
    it 'assigns a new entry record' do
      get :new
      assigns(:entry).should be_a_new(Entry)
    end
    it 'responds with success' do
      get :new
      response.code.should eq('200')
    end
    it 'assigns a total_time for entries of a given day and user' do
      entry = Factory(:entry, :user => @user)
      get :new, :day => entry.day.strftime("%Y-%m-%d")
      assigns(:total_time).should eq(entry.duration_hours)
    end
  end

  context 'POST on create with entry with associations' do
    before(:each) do
      @user = Factory(:user)
      @project = Factory(:project)
      @task = Factory(:task)
      @entry = Factory.attributes_for(:entry)
      post :create, :entry => @entry.merge( { :task_id => @task.id,
                                           :project_id => @project.id } )
    end
    it('responds with a redirect') { response.code.should eq('302') }
    it('creates a new entry') { assigns(:entry).should_not be_a_new_record }
    it 'creates a new entry with associated project' do
      Entry.first.project.shortname.should eq(@project.shortname)
    end
    it 'creates a new entry with associated task' do
      Entry.first.task.name.should eq(@task.name)
    end
    it 'creates a new entry with associated user' do
      Entry.first.user.username.should eq(@user.username)
    end
    it 'displays a positive flash message with a valid request' do
      request.flash.try(:notice).should_not be_nil
    end
    it 'redirects to new_entry_path' do
      response.should redirect_to(new_entry_path + "?day=" + \
                                  @entry[:day].strftime("%Y-%m-%d"))
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
    it 'does not create a new entry without a duration and start/end' do
      @entry.delete(:duration_hours)
      @entry.delete(:start)
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
    it 'has an errors hash with missing associations' do
      post :create, :entry => @entry.merge( { :task_id => @task.id } )
      assigns(:entry).errors.should_not be_empty
    end
  end

end
