class AddWageToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :wage, :integer, :null => false, :default => 90
  end

  def self.down
    remove_column :projects, :wage
  end
end
