module EntriesHelper
  def prepare_tasks_variable
    update_page_tag do |page|
      page.assign 'tasks', @tasks_by_project
    end
  end
end
