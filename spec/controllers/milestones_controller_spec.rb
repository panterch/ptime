require 'spec_helper'

describe MilestonesController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user, :admin => true)
    @project = Factory.create(:project)
    sign_in @user
  end

  describe '#create' do
    before(:each) do
      milestone_type = Factory(:milestone_type)
      @milestone = Factory.attributes_for(:milestone,
        :milestone_type_id => milestone_type.id,
        :reached => true)
    end

    context 'with missing parameters' do
      it 'does not create an entry without a milestone type' do
        post_with_invalid_position :milestone_type_id
        Milestone.first.should be_nil
      end

      it 'yields an error with a missing parameter' do
        post_with_invalid_position :milestone_type_id
        assigns(:milestone).errors.should_not be_empty
      end

      it 'renders new milestone form afterwards' do
        post_with_invalid_position :milestone_type_id
        response.should render_template('milestones/new')
      end

      def post_with_invalid_position(element)
        @milestone.delete(element)
        post :create, :milestone => @milestone, :project_id => @project.id
      end
    end

    context 'with required parameters' do
      it 'creates a new entry with an associated project' do
        do_post
        Milestone.first.project.shortname.should eq(@project.shortname)
      end

      it 'displays a success flash message' do
        do_post
        request.flash.try(:notice).should_not be_nil
      end

      it 'twice creates two new entries' do
        do_post
        expect { do_post }.to change{ Milestone.count }.from(1).to(2)
      end

      it 'redirects to milestone index' do
        do_post
        response.should redirect_to(project_milestones_path)
      end

      context 'assigns the reached flag' do
        before(:each) do
          milestone_type = Factory(:milestone_type)
          @past_milestone = Factory(:milestone,
            :milestone_type_id => milestone_type.id,
            :created_at => Date.parse('2011-01-01'),
            :reached => false,
            :project_id => @project.id)
        end

        it 'not to the most recently saved record' do
          do_post
          Milestone.find(@past_milestone.id).reached.should be_false
        end

        it 'to the current record' do
          do_post
          Milestone.where("id != ?", @past_milestone.id).first.reached.should be_true
        end
      end

      def do_post
        post :create, :milestone => @milestone, :project_id => @project.id
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      @milestone = Factory(:milestone, :project_id => @project.id)
      delete :destroy, :id => @milestone.id, :project_id => @project.id
    end

    it 'destroys the milestone' do
      request.flash.try(:notice).should eq "Successfully destroyed milestone."
    end

    it 'redirects to the milestones index' do
      response.should redirect_to(project_milestones_url(@project))
    end
  end
end
