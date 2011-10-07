class AddProbabilityToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :probability, :integer, :default => 0
  end
end
