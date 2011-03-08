class FixProjectName < ActiveRecord::Migration
  def self.up
    rename_column :projects, :name, :shortname
  end

  def self.down
    rename_column :projects, :shortname, :name
  end
end
