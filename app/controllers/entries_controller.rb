class EntriesController < InheritedResources::Base
  before_filter :get_active_projects, :only => [:new, :edit, :index]
  before_filter :populate_search, :only => :index
  before_filter :get_users, :only => :index

  respond_to :csv, :only => :index

  def create
    create! do
        @entry.user = current_user
        @entry.save
        new_entry_path
    end
  end

  def index
    index! do |format|
      format.csv do 
        send_data @search.all.to_comma, :type => 'text/csv',
          :filename=>"report_#{Date.today}.csv"
      end
    end
  end

  # Show active tasks associated to project
  def update_tasks_select
    tasks = Task.active.with_project_id(params[:id]).\
      order(:name) unless params[:id].blank?
    render :partial => "tasks_select", :locals => { :tasks => tasks }
  end


  private

  # Display only active projects
  def get_active_projects
    @active_projects = Project.active.collect do |p|
      [p.shortname, p.id] 
    end
  end

  def collection
    @entries ||= @search.all.paginate(:per_page => 3, :page => params[:page])
  end

  # Initialize meta_search's collection
  def populate_search
    @search = Entry.search(params[:search])
  end

  def get_users
    @users = User.all
  end

end
