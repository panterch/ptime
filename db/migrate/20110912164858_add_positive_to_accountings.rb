class AddPositiveToAccountings < ActiveRecord::Migration
  def self.up
    add_column :accountings, :positive, :boolean, :null => false

    Accounting.all.each do |accounting|
      accounting.positive = accounting.amount >= 0 ? true : false
      accounting.save!
    end
  end

  def self.down
    remove_column :accountings, :positive
  end
end
