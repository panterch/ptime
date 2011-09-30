class AddDeletedFlag < ActiveRecord::Migration
  def self.up
    add_column :users,       :deleted_at, :datetime
    add_column :projects,    :deleted_at, :datetime
    add_column :tasks,       :deleted_at, :datetime
    add_column :entries,     :deleted_at, :datetime
    add_column :accountings, :deleted_at, :datetime
    add_column :milestones,  :deleted_at, :datetime
  end

  def self.down
    remove_column :milestones,  :deleted_at
    remove_column :accountings, :deleted_at
    remove_column :entries,     :deleted_at
    remove_column :tasks,       :deleted_at
    remove_column :projects,    :deleted_at
    remove_column :users,       :deleted_at
  end
end
