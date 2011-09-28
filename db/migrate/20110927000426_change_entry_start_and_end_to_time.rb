class ChangeEntryStartAndEndToTime < ActiveRecord::Migration
  def self.up
    change_column :entries, :start, :time
    change_column :entries, :end, :time
  end

  def self.down
    change_column :entries, :start, :datetime
    change_column :entries, :end, :datetime
  end
end
