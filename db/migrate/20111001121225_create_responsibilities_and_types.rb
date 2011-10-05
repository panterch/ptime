class CreateResponsibilitiesAndTypes < ActiveRecord::Migration
  def up
    create_table :responsibilities do |t|
      t.integer :responsibility_type_id
      t.integer :project_id
      t.integer :user_id
      t.boolean :deleted_at

      t.timestamps
    end

    create_table :responsibility_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :responsibilities
    drop_table :responsibility_types
  end
end
