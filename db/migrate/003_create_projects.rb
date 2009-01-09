class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      # t.column :name, :string
      t.column :desc, :string
    end
    add_column :entries, :project_id, :integer
  end

  def self.down
    drop_table :projects
    remove_column :entries, :project_id
  end
end
