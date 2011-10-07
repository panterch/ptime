class AddRplToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :rpl, :integer
  end

  def self.down
    remove_column :projects, :rpl
  end
end
