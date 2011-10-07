require 'spec_helper'

describe ResponsibilityTypesController do
  include Devise::TestHelpers
  before(:each) do
    @user = Factory.create(:user, :admin => true)
    sign_in @user
  end

  describe '#create' do
    before(:each) do
      @responsibility_type = Factory.attributes_for(:responsibility_type)
    end

    context 'with missing parameters' do
      it 'does not create an entry without a name' do
        post_with_invalid_position :name
        ResponsibilityType.first.should be_nil
      end

      it 'yields an error with a missing paramter' do
        post_with_invalid_position :name
        assigns(:responsibility_type).errors.should_not be_empty
      end

      it 'renders new responsibility type form afterwards' do
        post_with_invalid_position :name
        response.should render_template('responsibility_types/new')
      end

      def post_with_invalid_position(element)
        @responsibility_type.delete(element)
        post :create, :responsibility_type => @responsibility_type
      end
    end

    context 'with required parameters' do
      it 'creates a new entry' do
        do_post
        ResponsibilityType.first.name.should eq(@responsibility_type[:name])
      end

      it 'displays a success flash message' do
        do_post
        request.flash.try(:notice).should_not be_nil
      end

      it 'twice creates two new entries' do
        do_post
        expect { do_post }.to change{ ResponsibilityType.count }.from(1).to(2)
      end

      def do_post
        post :create, :responsibility_type => @responsibility_type
      end
    end
  end

  describe '#update' do
    before(:each) do
      @responsibility_type = Factory(:responsibility_type)
    end

    context 'with required parameters' do
      it 'doesn\'t create another responsibility_type' do
        expect { do_put }.to_not change { ResponsibilityType.count }
      end

      it 'displays a success flash message' do
        do_put
        request.flash.try(:notice).should_not be_nil
      end

      it 'redirects to responsibility_type index' do
        do_put
        response.should redirect_to(responsibility_types_path)
      end

      def do_put
        put :update,
          :responsibility_type => Factory.attributes_for(:responsibility_type),
          :id => @responsibility_type.id
      end
    end

    context 'without required parameters' do
      it 'does not update the record' do
        res_type_attributes = Factory.attributes_for(:responsibility_type,
                                                     :name => '')
        put :update, :responsibility_type => res_type_attributes,
          :id => @responsibility_type.id
        assigns(:responsibility_type).errors.should_not be_empty
        ResponsibilityType.first.name.should_not eq('')
      end
    end
  end
end
