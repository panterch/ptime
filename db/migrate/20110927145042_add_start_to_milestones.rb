class AddStartToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :start, :date
  end
end
