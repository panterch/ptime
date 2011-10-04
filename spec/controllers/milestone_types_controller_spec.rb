require 'spec_helper'

describe MilestoneTypesController do
  include Devise::TestHelpers
  before(:each) do
    @user = Factory.create(:user, :admin => true)
    sign_in @user
  end

  describe '#create' do
    before(:each) do
      @milestone_type = Factory.attributes_for(:milestone_type)
    end

    context 'with missing parameters' do
      it 'does not create an entry without a name' do
        post_with_invalid_position :name
        MilestoneType.first.should be_nil
      end

      it 'yields an error with a missing paramter' do
        post_with_invalid_position :name
        assigns(:milestone_type).errors.should_not be_empty
      end

      it 'renders new milestone type form afterwards' do
        post_with_invalid_position :name
        response.should render_template('milestone_types/new')
      end

      def post_with_invalid_position(element)
        @milestone_type.delete(element)
        post :create, :milestone_type => @milestone_type
      end
    end

    context 'with required parameters' do
      it 'creates a new entry' do
        do_post
        MilestoneType.first.name.should eq(@milestone_type[:name])
      end

      it 'displays a success flash message' do
        do_post
        request.flash.try(:notice).should_not be_nil
      end

      it 'twice creates two new entries' do
        do_post
        expect { do_post }.to change{ MilestoneType.count }.from(1).to(2)
      end

      def do_post
        post :create, :milestone_type => @milestone_type
      end
    end
  end

  describe '#update' do
    before(:each) do
      @milestone_type = Factory(:milestone_type)
    end

    context 'with required parameters' do
      it 'doesn\'t create another milestone_type ' do
        expect { do_put }.to_not change { MilestoneType.count }
      end

      it 'displays a success flash message' do
        do_put
        request.flash.try(:notice).should_not be_nil
      end

      it 'redirects to milestone_type index' do
        do_put
        response.should redirect_to(milestone_types_path)
      end

      def do_put
        put :update, :milestone_type => Factory.attributes_for(:milestone_type), :id => @milestone_type.id
      end
    end

    context 'without required parameters' do
      it 'does not update the record' do
        milestone_type_attributes = Factory.attributes_for(:milestone_type, :name => '')
        put :update, :milestone_type => milestone_type_attributes, :id => @milestone_type.id
        assigns(:milestone_type).errors.should_not be_empty
        MilestoneType.first.name.should_not eq('')
      end
    end
  end
end
