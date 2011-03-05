class EntriesController < InheritedResources::Base
  def create
    @entry = Entry.new(params[:entry])
    @entry.user = current_user
    @entry.save
    redirect_to entries_path
  end

  def update_tasks_select
    tasks = Task.where(:project_id => params[:id]).order(:name) unless params[:id].blank?
    render :partial => "tasks_select", :locals => { :tasks => tasks }
  end

end
