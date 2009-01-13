class ProjectsController < ApplicationController

  permit 'admin'

  layout 'time'

  def index
    # access date's entries
    @projects = Project.find(:all, :order => 'inactive, description')
    # create new record for new record editing
    @projects.insert(0, new_project)

    # @project holds the current editable project. This can be requested via
    # the parameter :id or this can be the new record. There are 3 cases:
    # 1: Create case: enter the site, no record selected
    # 2: Edit case:   the user choosed a record to edit, params[:id] is set
    # 3: Persist, Error case: @project alreadey holds a record
    if (nil == @project)
      @project = @projects[0]
      # id submitted: this is an edit request
      if wanted_id = params[:id]
       @projects.each { |p| @project = p if wanted_id.to_i == p.id }
      end
    end

    # the view can submit us a variable task_display holding the
    # current state of the tasks table visibility, but the default is none
    @tasks_display = params[:tasks_display] || 'none'
    render :template => 'projects/index'
  end

  # create or update a record
  def persist
    # persist the project
    if params[:project][:id].empty?
      create
    else
      update
    end
    index
  end

  # Creates an empty project holding the default tasks. The tasks
  # are already numbered, so the view can handly them like persisted
  # active records. To distinguish from an already persisted project, you
  # can always query the field project.id - if it's nil it's a new record
  def new_project
    project = Project.new
    project.tasks << Task.default_tasks
    # simulate ids to help view
    add_simulated_ids(project.tasks) 
    project
  end
  private

  # Access model to create and save new record
  def create
    @project = Project.new(params[:project])
    if @project.save
      # add submitted tasks to the project, order matters
      params[:task].keys.sort.each do |i|
        task = params[:task][i]
        @project.tasks.create(task)
      end
      flash.now[:notice] = 'Project was successfully created.'
    else
      # readd the simulated id's (indeed no so nice the whole handling of
      # this ids, but therefore we can use the same view...)
      add_simulated_ids(@project.tasks) 
    end
  end

  # this adds simulated id values to the submitted arrays members (should
  # be active records)
  def add_simulated_ids(tasks)
    tasks.each_index { |i| tasks[i].id = i }
  end

  # Access model to update an existing record
  def update
    @project = Project.find(params[:project][:id])
    if @project.update_attributes(params[:project])
      flash.now[:notice] = 'Project was successfully updated.'
      # @project = nil
      # persist updated tasks
      Task.update(params[:task].keys, params[:task].values) if params[:task]
    end
  end


end
