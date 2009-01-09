class RenameProjectDesc < ActiveRecord::Migration
  def self.up
    # cannot rename bec. desc is a sql keyword
    Project.destroy_all
    Entry.destroy_all
    remove_column 'projects', 'desc'
    add_column 'projects', 'description', :string
    remove_column 'entries', 'desc'
    add_column 'entries', 'description', :string
  end

  def self.down
    add_column 'projects', 'desc', :string
    remove_column 'projects', 'description'
    add_column 'entries', 'desc', :string
    remove_column 'entries', 'description'
  end
end
