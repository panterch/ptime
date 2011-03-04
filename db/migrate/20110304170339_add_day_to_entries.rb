class AddDayToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :day, :date
  end

  def self.down
    remove_column :entries, :day
  end
end
