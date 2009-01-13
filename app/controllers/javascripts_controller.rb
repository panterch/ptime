class JavascriptsController < ApplicationController

  def dynamic_tasks
    @tasks_by_project = Hash.new
    Task.all.each do |t|
      next if t.name.blank?
      @tasks_by_project[t.project_id] ||= []
      @tasks_by_project[t.project_id] << { :id => t.id, :name => t.name }
    end
  end
end
