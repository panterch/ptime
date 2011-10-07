class AddExternalFlagToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :external, :boolean, :default => true
  end
end
