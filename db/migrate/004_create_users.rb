class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :hashed_password, :string
    end
    add_column :entries, :user_id, :integer
  end

  def self.down
    drop_table :users
    remove_column :entries, :user_id
  end
end
