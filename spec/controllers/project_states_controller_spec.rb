require 'spec_helper'

describe ProjectStatesController do
  include Devise::TestHelpers
  before(:each) do
    @user = Factory.create(:user, :admin => true)
    sign_in @user
  end

  describe '#create' do
    before(:each) do
      @project_state = Factory.attributes_for(:project_state)
    end

    context 'with missing parameters' do
      it 'does not create an entry without a name' do
        post_with_invalid_position :name
        ProjectState.first.should be_nil
      end

      it 'yields an error with a missing paramter' do
        post_with_invalid_position :name
        assigns(:project_state).errors.should_not be_empty
      end

      it 'renders new project state form afterwards' do
        post_with_invalid_position :name
        response.should render_template('project_states/new')
      end

      def post_with_invalid_position(element)
        @project_state.delete(element)
        post :create, :project_state => @project_state
      end
    end

    context 'with required parameters' do
      before(:each) do
        do_post
      end

      it 'creates a new entry' do
        ProjectState.first.name.should eq(@project_state[:name])
      end

      it 'displays a success flash message' do
        request.flash.try(:notice).should_not be_nil
      end

      pending 'twice creates two new entries' do
        expect { do_post }.to change{ ProjectState.count }.from(1).to(2)
      end

      def do_post
        post :create, :project_state => @project_state
        assigns(:project_state).errors.should be_empty
      end
    end
  end

  describe '#update' do
    before(:each) do
      @project_state = Factory(:project_state)
    end

    context 'with required parameters' do
      it 'doesn\'t create another project state' do
        expect { do_put }.to_not change { ProjectState.count }
      end

      it 'displays a success flash message' do
        do_put
        request.flash.try(:notice).should_not be_nil
      end

      it 'redirects to project_state index' do
        do_put
        response.should redirect_to(project_states_path)
      end

      def do_put
        put :update,
          :project_state => Factory.attributes_for(:project_state),
          :id => @project_state.id
      end
    end

    context 'without required parameters' do
      it 'does not update the record' do
        state_attributes = Factory.attributes_for(:project_state,
                                                  :name => '')
        put :update, :project_state => state_attributes,
          :id => @project_state.id
        assigns(:project_state).errors.should_not be_empty
        ProjectState.first.name.should_not eq('')
      end
    end
  end
end
