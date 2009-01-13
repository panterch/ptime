class MakeAllCurrentUsersAdmins < ActiveRecord::Migration
  def self.up
    User.all.each { |u| u.admin = true }
  end

  def self.down
  end
end
