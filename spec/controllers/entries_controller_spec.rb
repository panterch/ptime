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
    after(:each) {
      Entry.delete_all
    }

    before(:each) { 
      user = Factory(:user)
      project = Factory(:project)
      task = Factory(:task)
      @entry = Factory.attributes_for(:entry)
      post :create, :entry => @entry.merge( {:user_id => user.id, 
                                           :task_id => task.id, 
                                           :project_id => project.id} )
    }
    it('responds with a redirect') { response.code.should eq('302') }
    it('creates a new entry') { assigns(:entry).should_not be_a_new_record }
    it('creates a new entry with associated project') {
      Entry.first.project.should_not be_nil
    }
    it('creates a new entry with associated task') {
      Entry.first.task.should_not be_nil
    }
    it('creates a new entry with associated user') {
      Entry.first.user.should_not be_nil
    }
  end

end
