class AdminController < InheritedResources::Base
  prepend_before_filter :only_admin

  def index
  end

  private

  def only_admin
    render_403 unless current_user.admin 
  end

end
