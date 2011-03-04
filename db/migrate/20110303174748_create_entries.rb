class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :task_id
      t.string :description
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
