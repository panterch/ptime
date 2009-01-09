class AddEntryColumnsBasic < ActiveRecord::Migration
  def self.up
    add_column :entries, :duration, :float
    add_column :entries, :date, :date
  end

  def self.down
    remove_column :entries, :date
    remove_column :entries, :duration
  end
end
