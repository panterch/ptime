class EntriesController < InheritedResources::Base
  before_filter :get_active_projects, :only => [:new, :edit, :index]
  before_filter :populate_search, :only => :index
  before_filter :get_users, :only => :index
  before_filter :get_tasks_by_project, :only => [:new, :edit, :index]

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
        send_data @search.all.to_comma, 
          :type => 'text/csv',
          :filename=>"report_#{Date.today}.csv"
      end
    end
  end


  private

  def get_active_projects
    @active_projects = Project.active
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

  # Prefetch all tasks and group them by projects
  def get_tasks_by_project
    @tasks_by_project = Hash.new
    Project.active.each do |p|
      @tasks_by_project[p.id] = p.tasks.map do |t| 
        { :id => t.id, :name => t.name }
      end
    end
  end

end
