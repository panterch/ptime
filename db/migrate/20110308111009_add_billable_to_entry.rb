class AddBillableToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :billable, :boolean
  end

  def self.down
    remove_column :entries, :billable
  end
end
