class AddBillableField < ActiveRecord::Migration
  def self.up
    add_column :tasks,   :billable, :boolean, :default => false
    add_column :entries, :billable, :boolean, :default => false
  end

  def self.down
    remove_column :tasks,   :billable
    remove_column :entries, :billable
  end
end
