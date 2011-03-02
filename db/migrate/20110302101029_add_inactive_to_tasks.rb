class AddInactiveToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :inactive, :boolean
  end

  def self.down
    remove_column :tasks, :inactive
  end
end
