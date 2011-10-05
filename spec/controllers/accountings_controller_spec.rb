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

      it 'redirects to accounting index' do
        do_post
        response.should redirect_to(project_accountings_path)
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

      it 'redirects to accounting index' do
        do_put
        response.should redirect_to(project_accountings_path)
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

  describe '#index' do
    before(:each) do
      @accounting = Factory(:accounting, :payed => false, :sent => false, :project_id => @project.id)
    end

    context 'sorting columns' do
      it 'by valuta' do
        second_accounting = Factory(:accounting, :valuta => '2010-07-01 02:00',
                                    :project_id => @project.id)
        third_accounting = Factory(:accounting, :valuta => '2011-11-01 02:00', 
                                   :project_id => @project.id)
        do_get 'valuta'
        assigns(:accountings).first.id.should eq(third_accounting.id)
      end

      it 'by payed flag' do
        second_accounting = Factory(:accounting, :payed => true,
                                    :project_id => @project.id)
        do_get 'payed'
        assigns(:accountings).first.id.should eq(second_accounting.id)
      end

      it 'by sent flag' do
        second_accounting = Factory(:accounting, :sent => true,
                                    :project_id => @project.id)
        do_get 'sent'
        assigns(:accountings).first.id.should eq(second_accounting.id)
      end

      it 'by amount' do
        second_accounting = Factory(:accounting, :amount => '0',
                                    :project_id => @project.id)
        third_accounting = Factory(:accounting, :amount => '9999',
                                   :project_id => @project.id)
        do_get 'amount'
        assigns(:accountings).first.id.should eq(third_accounting.id)
      end

      def do_get(column)
        get :index, :search => { :meta_sort => "#{column}.desc" },
          :project_id => @project.id
      end
    end

    context 'filtering columns' do
      it 'filters positive amounts (cash in)' do
        second_accounting = Factory(:accounting,
                                    :amount => -2, :project_id => @project.id)
        third_accounting = Factory(:accounting,
                                   :amount => -5, :project_id => @project.id)
        do_get :positive_is_true
        assigns(:accountings).first.id.should eq(@accounting.id)
        assigns(:accountings).count.should eq(1)
      end

      it 'filters negative amounts (cash out)' do
        second_accounting = Factory(:accounting,
                                    :amount => 2, :project_id => @project.id)
        third_accounting = Factory(:accounting,
                                   :amount => -5, :project_id => @project.id)
        do_get :positive_is_false
        assigns(:accountings).first.id.should eq(third_accounting.id)
        assigns(:accountings).count.should eq(1)
      end

      it 'filters payed flag' do
        second_accounting = Factory(:accounting,
                                    :payed => true, :project_id => @project.id)
        third_accounting = Factory(:accounting,
                                   :payed => false, :project_id => @project.id)
        do_get :payed_is_true
        assigns(:accountings).first.id.should eq(second_accounting.id)
        assigns(:accountings).count.should eq(1)
      end

      it 'filters sent flag' do
        second_accounting = Factory(:accounting,
                                    :sent => true, :project_id => @project.id)
        third_accounting = Factory(:accounting,
                                   :sent => false, :project_id => @project.id)
        do_get :sent_is_true
        assigns(:accountings).first.id.should eq(second_accounting.id)
        assigns(:accountings).count.should eq(1)
      end

      def do_get(filter)
        get :index, :search => { filter => '1' }, :project_id => @project.id
      end
    end

    context 'project return' do
      it 'calculates the return of the current project' do
        @project.rpl = 12
        @project.save
        # 20 hours = 1200 minutes
        Factory(:entry, :project_id => @project.id, :duration => '1200',
                :billable => true)
        another_project = Factory(:project)
        Factory(:accounting, :amount => 1100, :project_id => @project.id)
        Factory(:accounting, :amount => -500, :project_id => @project.id)
        Factory(:accounting, :amount => 100, :project_id => another_project.id)
        # Default accounting amount: 3299
        # past work = entry hours * wage
        # expected work = project rpl * wage
        # Project Return = cash-in - cash-out - past work - expected work
        # Project Return = 4399 - 500 - 20*90 - 12*90
        get :index, :project_id => @project.id
        assigns(:project_return).should eq(1019)
      end

      it 'sums amounts of the filtered accounting positions' do
        Factory(:accounting, :amount => 1100, :sent => true,
                :project_id => @project.id)
        Factory(:accounting, :amount => -500, :sent => true,
                :project_id => @project.id)
        Factory(:accounting, :amount => 100, :sent => false,
                :project_id => @project.id)
        # Default accounting amount: 3299
        get :index, :search => { :sent_is_true => '1' },
          :project_id => @project.id
        assigns(:project_return).should eq(600)
      end
    end

    context 'profitability' do
      before(:each) do
        @project = Factory(:project, :wage => '100', :rpl => '50')
        Factory(:accounting, :amount => 40000, :sent => true,
                :project_id => @project.id)
        Factory(:accounting, :amount => -2500, :sent => true,
                :project_id => @project.id)
        # Duration in minutes (20*60)
        Factory(:entry, :project_id => @project.id, :duration => '1200',
                :billable => true)
      end

      it 'calculates past work correctly' do
        get :index, :project_id => @project.id
        assigns(:past_work).should eq -2000
      end

      it 'calculates expected work correctly' do
        get :index, :project_id => @project.id
        assigns(:expected_work).should eq -5000
      end

      it 'calculates project return correctly.' do
        # Project Return = cash-in - cash-out - past work - expected work
        # Project Return = 40000 - 2500 - 20*100 - 50*100
        get :index, :project_id => @project.id
        assigns(:project_return).should eq 30500
      end

      it 'calculates the current profitability of a project' do
        # Profitability = (project return) / (cash-in) * 100
        # Profitability = 30500 / 40000 * 100
        get :index, :project_id => @project.id
        assigns(:project_profitability).should eq 76.25
      end

      it 'counts all time entries, billable or not' do
        # Project Return = cash-in - cash-out - past work - expected work
        # Project Return = 40000 - 2500 - 40*100 - 50*100
        # Profitability = (project return) / (cash-in) * 100
        # Profitability = 28500 / 40000 * 100
        Factory(:entry, :project_id => @project.id, :duration => '1200',
                :billable => false)
        get :index, :project_id => @project.id
        assigns(:project_profitability).should eq 71.25
      end
    end

    context 'profitability edge cases' do
      it 'handles zero cash-in correctly' do
        @project = Factory(:project, :wage => '100', :rpl => '50')
        get :index, :project_id => @project.id
        assigns(:project_return).should eq -5000
        assigns(:project_profitability).should eq 0
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

    it 'redirects to the accountings index' do
      response.should redirect_to(project_accountings_url(@project))
    end
  end
end
