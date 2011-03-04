class EntriesController < InheritedResources::Base
  def create
    @entry = Entry.new(params[:entry])
    @entry.user = current_user
    @entry.save
    redirect_to entries_path
  end
end
