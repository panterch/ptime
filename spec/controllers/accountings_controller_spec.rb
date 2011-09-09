require 'spec_helper'

describe AccountingsController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user)
    @project = Factory.create(:project)
    sign_in @user
  end

  context 'POST on create without valid values' do
    def post_invalid_position(element)
      @accounting.delete(element)
      post :create, :accounting => @accounting, :project_id => @project.id
    end

    before(:each) do
      @accounting = Factory.attributes_for(:accounting)
    end

    it 'does not create an entry without a description' do
      post_invalid_position :description
      Accounting.first.should be_nil
    end

    it 'does not create an entry without a amount' do
      post_invalid_position :amount
      Accounting.first.should be_nil
    end

    it 'does not create an entry without a valuta' do
      post_invalid_position :valuta
      Accounting.first.should be_nil
    end

    it 'does not create an entry without a valid project id' do
      expect {
        post :create, :accounting => @accounting, :project_id => @project.id+1
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'yields an error with a missing parameter' do
      post_invalid_position :description
      assigns(:accounting).errors.should_not be_empty
    end

    it 'renders new accounting form' do
      @accounting.delete(:description)
      post :create, :accounting => @accounting, :project_id => @project.id
      response.should render_template('accountings/new')
    end
  end

  context 'POST on create with required parameters' do
    before(:each) do
      accounting = Factory.attributes_for(:accounting)
      post :create, :accounting => accounting, :project_id => @project.id
    end

    it 'creates a new entry with an associated project' do
      Accounting.first.project.shortname.should eq(@project.shortname)
    end

    it 'displays a success flash message' do
      request.flash.try(:notice).should_not be_nil
    end

    it 'redirects to accounting index' do
      response.should redirect_to(project_accountings_path)
    end
  end

  # describe encountered bug
  context 'POST on create with flags' do
    it 'saves the flags to the database' do
      accounting = Factory.attributes_for(:accounting)
      post :create, :accounting => accounting.merge(
        { :payed => true, :sent => false } ), :project_id => @project.id
      Accounting.first.should_not be_nil
      Accounting.first.payed.should be_true
      Accounting.first.sent.should be_false
    end
  end

  context 'POST on create twice' do
    it 'stores the same position twice' do
      accounting = Factory.attributes_for(:accounting)
      post :create, :accounting => accounting, :project_id => @project.id
      Accounting.count.should eq(1)
      expect {
        post :create, :accounting => accounting, :project_id => @project.id
      }.to change{ Accounting.count }.from(1).to(2)
    end
  end
end


