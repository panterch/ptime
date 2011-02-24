class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.integer :estimate
      t.integer :project_id

      t.timestamps
    end

    add_index :tasks, :project_id
  end


  def self.down
    drop_table :tasks
  end
end
