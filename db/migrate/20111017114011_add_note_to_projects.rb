class AddNoteToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :note, :text
  end
end
