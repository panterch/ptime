class EntriesController < InheritedResources::Base
  def create
    @entry = Entry.new(params[:entry])
    @entry.user = current_user
    @entry.save
    redirect_to entries_path
  end

  # Show active tasks associated to project
  def update_tasks_select
    tasks = Task.where(:project_id => params[:id], :inactive => false).\
      order(:name) unless params[:id].blank?
    render :partial => "tasks_select", :locals => { :tasks => tasks }
  end

  def new
    @entry = Entry.new
    @active_projects = Project.where(:inactive => false).collect { |p| [p.shortname, p.id] }
  end

  def edit
    @entry = Entry.find(params[:id])
    @active_projects = Project.where(:inactive => false).collect { |p| [p.shortname, p.id] }
  end

end
