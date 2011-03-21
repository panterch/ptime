require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers
  context "admin test" do
    before (:each) do
      @user = Factory.create(:user, :admin=>true)
      sign_in @user
    end

    context 'GET on new' do
      before(:each) { get :new }
      it 'assigns a new user record' do
        assigns(:user).should be_a_new(User)
      end
      it 'responds with success' do
        response.should be_success
      end
    end

    context 'GET on show' do
      before(:each) do
        @user.save
        get :show, :id=>@user.id
      end
      it 'responds with redirect to edit' do
        response.should redirect_to :action=>:edit
      end
    end

    context 'GET on edit my self' do
      before(:each) { get :edit, :id => @user.id }
      it('responds with success') { response.should be_success }
    end
    context "persisted user" do
      let(:user) { Factory(:user) }
      context 'GET on edit my foreign user' do
        before(:each) do
          get :edit, :id => user
        end
        it('responds with success') { response.should be_success }
      end
      context 'GET on index' do
        before(:each) { get :index }
        it('responds with success') { response.should be_success }
      end

    end
  end
  context "no-admin test" do
    before (:each) do
      @user = Factory.create(:user, :admin=>false)
      sign_in @user
    end

    context 'GET on new' do
      before(:each) { get :new }
      it 'should not work for a user without admin-rights' do
        assigns(:user).should be_nil
      end
      it 'responds with success' do
        response.should redirect_to :controller=>:projects, :action=>:index
      end
    end
    context 'GET on show' do
      before(:each) do
        @user.save
        get :show, :id=>@user.id
      end
      it 'responds with redirect to edit' do
        response.should redirect_to :action=>:edit
      end
    end

    context 'GET on edit my self' do
      before(:each) { get :edit, :id => @user.id }
      it('responds with success') do
        response.should be_success
      end
    end

    context "persisted user" do
      let(:user) {Factory(:user) }
      context 'GET on edit foreign user' do
        before(:each) do
          get :edit, :id => user
        end
        it('responds redirect to root') do
          response.should redirect_to :controller=>:projects, :action=>:index
        end
      end
      context 'GET on index' do
        before(:each) { get :index }
        it('responds with success') do
          response.should redirect_to :controller=>:projects, :action=>:index
        end
      end

    end
  end
  context "unauthenticated test" do
    context 'GET on index' do
      before(:each) { get :index }
      it('responds redirect target') { response.should redirect_to(:controller=>"devise/sessions", :action=>"new") }
    end
    context 'GET on new' do
      before(:each) { get :new }
      it('responds redirect target') { response.should redirect_to(:controller=>"devise/sessions", :action=>"new") }
    end
  end
end
