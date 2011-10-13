class RenameInactiveToActiveForTasks < ActiveRecord::Migration
  def up
    rename_column :tasks, :inactive, :active

    Task.all.each do |task|
      task.active = !task.active
      task.save
    end
  end

  def down
    rename_column :tasks, :active, :inactive

    Task.all.each do |task|
      task.inactive = !task.inactive
      task.save
    end
  end
end
