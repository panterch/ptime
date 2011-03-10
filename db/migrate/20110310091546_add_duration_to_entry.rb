class AddDurationToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :duration, :integer
  end

  def self.down
    remove_column :entries, :duration
  end
end
