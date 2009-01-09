class AddTaskField < ActiveRecord::Migration
  def self.up
    add_column :entries, :task, :string
  end

  def self.down
    remove_column :entries, :task
  end
end
