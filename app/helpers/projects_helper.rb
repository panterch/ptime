module ProjectsHelper
  def add_task_link(name)
    link_to_function name do |page|
      page.insert_html :before, :add_task, :partial => 'task', :object => Task.new
    end
  end

  def fields_for_task(task, &block)
    prefix = task.new_record? ? 'new' : 'existing'
    fields_for("project[#{prefix}_task_attributes][]", task, &block)
  end

end
