# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  before_filter :authorize, :prepare_date

  def current_user
    @current_user
  end

  private
  
    def authorize
      # check for valid user_id in session
      if session[:user_id]
        @current_user = User.find(session[:user_id])
        if @current_user.inactive && !@current_user.admin?
          flash[:notice] = 'User inactivated'
          redirect_to( :controller => 'login', :action => 'login' )
          return false
        end
        return true
      end
      flash[:notice] = 'Please log in'
      redirect_to( :controller => 'login', :action => 'login' )
    end


    def prepare_date
      # these are the parameters like they are submitted by rails
      # select_date
      if d = params[:date]
        @date = Date.civil(Integer(d[:year]), Integer(d[:month]),
                       Integer(d[:day]))
      # JSCalendar submits 3 http parameters, notice: since these
      # parameters are coming from javascript, january is month 0 (zero)
      elsif params[:y] &&  params[:m] && params[:d] 
        @date = Date.civil(Integer(params[:y]), Integer(params[:m]) + 1,
                       Integer(params[:d]))
      # this is a show or an edit
      elsif @entry && @entry.date
        @date = @entry.date
      # when an entry is saved, we use the date submitted whitin
      elsif params[:entry]
        @date = params[:entry][:date]
        @date = Date.parse(params[:entry][:date]) unless @date.is_a? Date
      # the date in the session is the date that was last selected
      elsif session[:date]
        @date = session[:date]
      # no date selected, fallback to today
      else
        @date = Date.today
      end
      session[:date] = @date
    end

  

end
