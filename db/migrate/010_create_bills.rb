class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :project_id, :integer
    end
    add_column :entries, :bill_id, :integer
  end

  def self.down
    drop_table :bills
    remove_column :entries, :bill_id
  end
end
