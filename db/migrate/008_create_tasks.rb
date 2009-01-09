class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :name, :string
      t.column :estimation, :float
      t.column :project_id, :integer
    end
    add_column :entries, :task_id, :integer
    remove_column :entries, :task
  end

  def self.down
    drop_table :tasks
    remove_column :entries, :task_id
    add_column :entries, :task, :string
  end
end
