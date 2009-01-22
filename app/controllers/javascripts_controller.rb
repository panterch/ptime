class JavascriptsController < ApplicationController

  def dynamic_tasks
    @tasks_by_project = Hash.new
    @current_user.projects.each do |p|
      @tasks_by_project[p.id] = p.tasks.map{|t| { :id => t.id, :name => t.name }}
    end
  end
end
