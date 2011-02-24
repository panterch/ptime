require 'spec_helper'

describe ProjectsController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user)
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
  end
  
  context 'POST on create' do
    before(:each) { post :create, :project => Factory.attributes_for(:project) }
    it('responds with a redirect') { response.code.should eq('302') }
    it('creates a new project') { assigns(:project).should_not be_a_new_record }
  end

  context 'persisted project' do
    let(:project) { Factory(:project) }
    context 'GET on edit' do
      before(:each) { get :edit, :id => project }
      it('respons with success'){ response.code.should eq('200') }
    end
    context 'GET on index' do
      before(:each) { get :index }
      it('respons with success'){ response.code.should eq('200') }
      it('assigns projects'){ assigns(:projects).should eq([project]) }
    end
  end


end
