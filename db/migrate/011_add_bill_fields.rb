class AddBillFields < ActiveRecord::Migration
  def self.up
    add_column :bills, :start, :date
    add_column :bills, :end, :date
    add_column :bills, :user_id, :integer
    add_column :bills, :created_at, :datetime
    add_column :bills, :updated_at, :datetime
  end

  def self.down
    remove_column :bills, :start
    remove_column :bills, :end
    remove_column :bills, :user_id
    remove_column :bills, :created_at
    remove_column :bills, :updated_at
  end
end
