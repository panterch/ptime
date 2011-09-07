require 'spec_helper'

describe AccountingsController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user)
    sign_in @user
  end

  context 'POST on create without valid values' do
    before(:each) do
      project = Factory(:project)
      @accounting = Factory.attributes_for(:accounting)
      @accounting = @accounting.merge( { :project_id => project.id } )
    end

    it 'does not create an entry without a description' do
      @accounting.delete(:description)
      post :create, :accounting => @accounting
      Accounting.first.should be_nil
    end

    it 'does not create an entry without a amount' do
      @accounting.delete(:amount)
      post :create, :accounting => @accounting
      Accounting.first.should be_nil
    end

    it 'does not create an entry without a valuta' do
      @accounting.delete(:valuta)
      post :create, :accounting => @accounting
      Accounting.first.should be_nil
    end

    it 'does not create an entry without a project id' do
      @accounting.delete(:project_id)
      post :create, :accounting => @accounting
      Accounting.first.should be_nil
    end

    it 'yields an error with a missing parameter' do
      @accounting.delete(:description)
      post :create, :accounting => @accounting
      assigns(:accounting).errors.should_not be_empty
    end

    it 'renders new accounting form' do
      @accounting.delete(:description)
      post :create, :accounting => @accounting
      response.should render_template('accountings/new')
    end
  end

  context 'POST on create with required parameters' do
    before(:each) do
      @project = Factory(:project)
      @accounting = Factory.attributes_for(:accounting)
      post :create, :accounting => @accounting.merge(
        { :project_id => @project.id } )
    end

    it 'creates a new entry with an associated project' do
      Accounting.first.project.shortname.should eq(@project.shortname)
    end

    it 'displays a success flash message' do
      request.flash.try(:notice).should_not be_nil
    end

    it 'redirects to accounting index' do
      response.should redirect_to(accountings_path)
    end
  end
end


