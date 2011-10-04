require 'spec_helper'

describe ResponsibilitiesController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user, :admin => true)
    @project = Factory.create(:project)
    sign_in @user
  end

  describe '#create' do
    before(:each) do
      @responsibility = Factory.attributes_for(:responsibility)
    end

    context 'with missing parameters' do
      before(:each) do
        post :create, :responsibility => @responsibility,
          :project_id => @project.id
      end

      it 'does not create an entry without a responsibility type' do
        # It only contains the default project responsibilities
        Responsibility.count.should eq 2
      end

      it 'renders new responsibility form afterwards' do
        response.should render_template('responsibilities/new')
      end
    end

    context 'with required parameters' do
      it 'creates a new entry with an associated project' do
        do_post
        Responsibility.first.project.shortname.should eq(@project.shortname)
      end

      it 'displays a success flash message' do
        do_post
        request.flash.try(:notice).should_not be_nil
      end

      it 'twice creates two new responsibilties' do
        do_post
        expect { do_post }.to change{ Responsibility.count }.from(3).to(4)
      end

      it 'redirects to responsibility index' do
        do_post
        response.should redirect_to(project_responsibilities_path)
      end

      def do_post
        responsibility_type = Factory(:responsibility_type)
        post :create, :responsibility => @responsibility.merge(:responsibility_type_id => responsibility_type.id), :project_id => @project.id
      end
    end
  end

  describe '#update' do
    before(:each) do
      @responsibility = Factory(:responsibility, :project_id => @project.id)
    end

    context 'with required parameters' do
      it 'doesn\'t create another responsibility position' do
        expect { do_put }.to_not change { Responsibility.count }
      end

      it 'displays a success flash message' do
        do_put
        request.flash.try(:notice).should_not be_nil
      end

      it 'redirects to responsibility index' do
        do_put
        response.should redirect_to(project_responsibilities_path)
      end

      def do_put
        put :update, :responsibility => Factory.attributes_for(:responsibility), :project_id => @project.id, :id => @responsibility.id
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      @responsibility = Factory(:responsibility, :project_id => @project.id)
      delete :destroy, :id => @responsibility.id, :project_id => @project.id
    end

    it 'destroys the responsibility' do
      request.flash.try(:notice).should eq "Successfully destroyed responsibility."
    end

    it 'redirects to the responsibilities index' do
      response.should redirect_to(project_responsibilities_url(@project))
    end
  end
end
