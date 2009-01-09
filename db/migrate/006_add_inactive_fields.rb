class AddInactiveFields < ActiveRecord::Migration
  def self.up
    add_column :projects, :inactive, :boolean
    add_column :users, :inactive, :boolean
  end

  def self.down
    remove_column :projects, :inactive
    remove_column :users, :inactive
  end
end
