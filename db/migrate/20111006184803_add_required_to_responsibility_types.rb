class AddRequiredToResponsibilityTypes < ActiveRecord::Migration
  def change
    add_column :responsibility_types, :required, :boolean
  end
end
