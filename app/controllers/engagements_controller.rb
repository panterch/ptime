class EngagementsController < ApplicationController

  before_filter :load_project

  def new
    @engagement = Engagement.new
  end

  def create
    @engagement = Engagement.new
    user = User.find_by_email(params[:email])
    if user
      unless user.projects.include?(@project)
        user.projects << @project
      end
      flash[:notice] = 'User added'
      redirect_to projects_url
    else
      @engagement.errors.add_to_base('This user is not yet a member, please let him sign up.')
      render :template => 'engagements/new'
    end
  end

  protected

    def load_project
      @project = @current_user.projects.find(params[:project_id])
    end

end
