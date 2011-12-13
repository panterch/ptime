class AddRplExtAndCurrentWorktimeExtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :rpl_ext, :integer, :default => 0
    add_column :projects, :current_worktime_ext, :integer, :default => 0
  end
end
