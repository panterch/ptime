class CreateAccountings < ActiveRecord::Migration
  def self.up
    create_table :accountings do |t|
      t.string :description
      t.integer :amount
      t.datetime :valuta
      t.integer :project_id
      t.boolean :sent
      t.boolean :payed
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :accountings
  end
end
