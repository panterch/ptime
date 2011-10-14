class AddExternalFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :external, :boolean
  end
end
