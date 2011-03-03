class CreateProjectStates < ActiveRecord::Migration
  def self.up
    create_table :project_states do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :project_states
  end
end
