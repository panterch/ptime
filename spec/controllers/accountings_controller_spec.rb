require 'spec_helper'

describe AccountingsController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user, :admin => true)
    @project = Factory.create(:project)
    sign_in @user
  end

  describe '#create' do
    before(:each) do
      @accounting = Factory.attributes_for(:accounting)
    end

    context 'with missing parameters' do
      it 'does not create an entry without a description' do
        post_with_invalid_position :description
        Accounting.first.should be_nil
      end

      it 'does not create an entry without a amount' do
        post_with_invalid_position :amount
        Accounting.first.should be_nil
      end

      it 'does not create an entry without a valuta' do
        post_with_invalid_position :valuta
        Accounting.first.should be_nil
      end

      it 'yields an error with a missing parameter' do
        post_with_invalid_position :description
        assigns(:accounting).errors.should_not be_empty
      end

      it 'renders new accounting form afterwards' do
        post_with_invalid_position :description
        response.should render_template('accountings/new')
      end

      def post_with_invalid_position(element)
        @accounting.delete(element)
        post :create, :accounting => @accounting, :project_id => @project.id
      end
    end

    context 'with required parameters' do
      it 'creates a new entry with an associated project' do
        do_post
        Accounting.first.project.shortname.should eq(@project.shortname)
      end

      it 'displays a success flash message' do
        do_post
        request.flash.try(:notice).should_not be_nil
      end

      it 'twice creates two new entries' do
        do_post
        expect { do_post }.to change{ Accounting.count }.from(1).to(2)
      end

      it 'redirects to project edit dialog' do
        do_post
        response.should redirect_to(edit_project_path(@project))
      end

      def do_post
        post :create, :accounting => @accounting, :project_id => @project.id
      end
    end

    context 'bug during with declared flags in UI' do
      it 'saves these flags to the database' do
        post :create, :accounting => @accounting.merge(
          { :payed => true, :sent => false } ), :project_id => @project.id
          Accounting.first.should_not be_nil
          Accounting.first.payed.should be_true
          Accounting.first.sent.should be_false
      end
    end
  end

  describe '#update' do
    before(:each) do
      @accounting = Factory(:accounting, :project_id => @project.id)
    end

    context 'with required parameters' do
      it 'doesn\'t create another accounting position' do
        expect { do_put }.to_not change { Accounting.count }
      end

      it 'displays a success flash message' do
        do_put
        request.flash.try(:notice).should_not be_nil
      end

      it 'redirects to project edit dialog' do
        do_put
        response.should redirect_to(edit_project_path(@project))
      end

      def do_put
        put :update, :accounting => Factory.attributes_for(:accounting), :project_id => @project.id, :id => @accounting.id
      end
    end

    context 'without required parameters' do
      it 'does not update the record' do
        accounting_attributes = Factory.attributes_for(:accounting, :amount => '', :project_id => @project.id)
        put :update, :accounting => accounting_attributes, :project_id => @project.id, :id => @accounting.id
        assigns(:accounting).errors.should_not be_empty
        Accounting.first.amount.should_not eq('')
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      @accounting = Factory(:accounting, :project_id => @project.id)
      delete :destroy, :id => @accounting.id, :project_id => @project.id
    end

    it 'destroys the accounting' do
      request.flash.try(:notice).should eq "Successfully destroyed accounting."
    end

    it 'redirects to the project edit dialog' do
      response.should redirect_to(edit_project_url(@project))
    end
  end
end
