require 'spec_helper'

describe ProjectsController do
  include Devise::TestHelpers
  before (:each) do
    @user = Factory.create(:user, :admin => true)
    sign_in @user
  end

  context 'GET on new' do
    before(:each) { get :new }
    it 'assigns a new project record' do
      assigns(:project).should be_a_new(Project)
    end
    it 'responds with success' do
      response.code.should eq('200')
    end
    it('creates a new project with default tasks') do
      assigns(:project).tasks.should_not be_empty
    end
  end

  context 'POST on create' do
    before(:each) do
      project_attributes = generate_valid_project_attributes
      post :create, :project => project_attributes
    end
    it('does not have errors') { assigns(:project).errors.should be_empty }
    it('responds with a redirect') { response.code.should eq('302') }
    it('creates a new project') { assigns(:project).should_not be_a_new_record }
  end

  context 'POST on create with project with associated task' do
    before(:each) do
      project_attributes = generate_valid_project_attributes
      @project = project_attributes.merge(
          {:tasks_attributes => [{:name => "First task", :inactive => false}]})
      post :create, :project => @project
    end
    it('responds with a redirect') { response.code.should eq('302') }
    it('creates a new project') { assigns(:project).should_not be_a_new_record }
    it('creates a new project with associated task') do
      Project.find_by_shortname(@project[:shortname]).tasks.should_not be_empty
    end
  end

  context 'Find existing project' do
    before(:each) do
      project_state = Factory(:project_state)
      @project = Factory(:project, :shortname => "xyz-987",
                         :description => "project_1", :inactive => false,
                         :project_state_id => project_state.id)
    end

    context 'GET on edit' do
      it('responds with success') do
        get :edit, :id => @project.id
        response.code.should eq('200')
      end

      before(:each) do
        @accounting = Factory(:accounting, :payed => false, :sent => false,
                              :project_id => @project.id)
      end

      describe 'sorting accounting positions' do
        it 'by valuta' do
          second_accounting = Factory(:accounting,
                                      :valuta => '2010-07-01 02:00',
                                      :project_id => @project.id)
          third_accounting = Factory(:accounting,
                                     :valuta => '2011-11-01 02:00',
                                     :project_id => @project.id)
          do_get 'valuta'
          # accountings are sorted by valuta by default
          assigns(:accountings).last.id.should eq(third_accounting.id)
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
          get :edit, :search => { :meta_sort => "#{column}.desc" },
            :id => @project.id
        end
      end

      describe 'filtering accounting positions' do
        it 'filters positive amounts (cash in)' do
          second_accounting = Factory(:accounting,
                                      :amount => -2,
                                      :project_id => @project.id)
          third_accounting = Factory(:accounting,
                                     :amount => -5,
                                     :project_id => @project.id)
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
                                      :payed => true,
                                      :project_id => @project.id)
          third_accounting = Factory(:accounting,
                                     :payed => false,
                                     :project_id => @project.id)
          do_get :payed_is_true
          assigns(:accountings).first.id.should eq(second_accounting.id)
          assigns(:accountings).count.should eq(1)
        end

        it 'filters sent flag' do
          second_accounting = Factory(:accounting,
                                      :sent => true,
                                      :project_id => @project.id)
          third_accounting = Factory(:accounting,
                                     :sent => false,
                                     :project_id => @project.id)
          do_get :sent_is_true
          assigns(:accountings).first.id.should eq(second_accounting.id)
          assigns(:accountings).count.should eq(1)
        end

        def do_get(filter)
          get :edit, :search => { filter => '1' }, :id => @project.id
        end
      end
    end

    context 'GET on index' do
      it('responds with success') do
        get :index
        response.code.should eq('200')
      end
      it('assigns projects') do
        get :index
        assigns(:projects).should eq([@project])
      end

      describe 'sort projects table' do
        it 'sorts by id asc by default' do
          get :index
          assigns(:projects).first.shortname.should eq(@project.shortname)
        end
        it 'sorts by shortname desc when asked to' do
          project_2 = Factory(:project, :shortname => "zyx-555",
                             :description => "project_2")
          get :index, { :search => { 'meta_sort' => 'shortname.desc' } }
          assigns(:projects).first.shortname.should eq(project_2.shortname)
        end
      end

      describe 'filter projects table' do
        it 'filters by inactive state when asked to' do
          second_project = Factory(:project, :inactive => true)
          do_get :inactive_is_true
          assigns(:projects).first.id.should eq(second_project.id)
          assigns(:projects).count.should eq(1)
        end

        it 'filters by external flag when asked to' do
          second_project = Factory(:project, :external => false)
          do_get :external_is_false
          assigns(:projects).first.id.should eq(second_project.id)
          assigns(:projects).count.should eq(1)
        end

        it 'filters by active state when asked to' do
          second_project = Factory(:project, :inactive => true)
          do_get :inactive_is_false
          assigns(:projects).first.id.should eq(@project.id)
          assigns(:projects).count.should eq(1)
        end

        it 'filters by project state when asked to' do
          project_state = Factory(:project_state, :name => 'won')
          project_state.id.should_not eq(@project.project_state_id)
          second_project = Factory(:project, :inactive => true,
                                   :project_state_id => project_state.id)
          get :index,
            :search => { :project_state_id_equals => @project.project_state_id }
          assigns(:projects).first.id.should eq(@project.id)
          assigns(:projects).count.should eq(1)
        end

        def do_get(filter)
          get :index, :search => { filter => '1' }
        end
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      @project = Factory(:project)
      delete :destroy, :id => @project.id
    end

    it 'destroys the project' do
      request.flash.try(:notice).should eq "Successfully destroyed project."
    end

    it 'redirects to the projects index' do
      response.should redirect_to(projects_path)
    end
  end
end
