class ReportsController < ApplicationController

  # reports arent saved yet to the db, they simply exist in the session

  def new
    @report = session[:report] || @current_user.reports.build
  end

  def create
    @report = @current_user.reports.build(params[:report])
    @report.valid?
    respond_to do |format|
      format.html { render :template => 'reports/new.html.haml' }
    end
  end

  protected

end
