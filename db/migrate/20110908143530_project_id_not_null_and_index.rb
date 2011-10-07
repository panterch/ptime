class ProjectIdNotNullAndIndex < ActiveRecord::Migration
  def self.up
    change_column :accountings, :project_id, :integer, :null => false
    add_index :accountings, :project_id
  end

  def self.down
    remove_index :accountings, :project_id
    change_column :accountings, :project_id, :integer, :null => true
  end
end
