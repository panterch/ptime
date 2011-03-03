class AddProjectStateIdToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :project_state_id, :integer
  end

  def self.down
    remove_column :projects, :project_state_id
  end
end
