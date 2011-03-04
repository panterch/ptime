require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers
  context "admin test" do
    before (:each) do
      @user = Factory.create(:user)
      sign_in @user
    end

    context 'GET on new' do
      before(:each) { get :new }
      it 'assigns a new user record' do
        assigns(:user).should be_a_new(User)
      end
      it 'responds with success' do
        response.code.should eq('200')
      end
    end

    context "persisted user" do
      let(:user) { Factory(:user, :email=>"nobody@panter.ch") }
      context 'GET on edit' do
        before(:each) { get :edit, :id => user }
        it('respons with success'){ response.code.should eq('200') }
      end
      context 'GET on index' do
        before(:each) { get :index }
        it('respons with success'){ response.code.should eq('200') }
      end

    end
  end
  context "unauthenticated test" do
    context 'GET on index' do
      before(:each) { get :index }
      it('respons redirect target'){ response.should redirect_to(:controller=>"devise/sessions", :action=>"new") }
    end
    context 'GET on new' do
      before(:each) { get :new }
      it('respons redirect target'){ response.should redirect_to(:controller=>"devise/sessions", :action=>"new") }
    end
  end
end
