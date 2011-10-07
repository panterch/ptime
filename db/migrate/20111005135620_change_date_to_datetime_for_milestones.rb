class ChangeDateToDatetimeForMilestones < ActiveRecord::Migration
  def up
    change_column :milestones, :start, :datetime
  end

  def down
    change_column :milestones, :start, :date
  end
end
