module ReportsHelper

  def project_options
    options_from_collection_for_select(@current_user.projects,
                                       'id', 'description')
  end

  def format_options
    options_from_collection_for_select(%w(html csv),
                                       'to_s', 'to_s')
  end

  def user_options
    '<option value=""></option>'+
    options_from_collection_for_select(
      @current_user.projects.map(&:users).flatten.uniq,
      'id', 'name')
  end

end
