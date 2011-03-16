module EntriesHelper

  # Build user select for entries report form
  def users_id_equals_select(form)
    users = @users.collect { |user| [user.username, user.id] }
    form.select :user_id_equals, users,  {:include_blank => ''}
  end

end
