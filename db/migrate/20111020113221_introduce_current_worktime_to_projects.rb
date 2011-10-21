class IntroduceCurrentWorktimeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :current_worktime, :integer, :default => 0
  end
end
