class AddPositiveToAccountings < ActiveRecord::Migration
  def self.up
    add_column :accountings, :positive, :boolean, :null => false
  end

  def self.down
    remove_column :accountings, :positive
  end
end
