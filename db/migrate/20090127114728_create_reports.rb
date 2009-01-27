class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.date :start_date
      t.date :end_date
      t.integer :project_id
      t.integer :user_id
      t.integer :about_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
