class AddPositionToProjectStates < ActiveRecord::Migration
  def change
    add_column :project_states, :position, :integer
  end
end
