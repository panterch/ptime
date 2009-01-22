class CreateEngagements < ActiveRecord::Migration
  def self.up
    create_table :engagements do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :role

      t.timestamps
    end
  end

  def self.down
    drop_table :engagements
  end
end
