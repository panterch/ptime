module UsersHelper
  def last_sign_in_date(user)
    user.try(:last_sign_in_at).try(:strftime, '%Y-%m-%d')
  end

  def last_entry_date(user)
    user.entries.last.try(:created_at).try(:strftime, '%Y-%m-%d')
  end
end
