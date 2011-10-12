class AddBillableByDefaultToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :billable_by_default, :boolean
  end
end
