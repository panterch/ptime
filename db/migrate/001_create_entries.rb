class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      # t.column :name, :string
      t.column :desc, :string
     # t.column :duration, :decimal, :null => false, :precision =>
    end
  end

  def self.down
    drop_table :entries
  end
end
