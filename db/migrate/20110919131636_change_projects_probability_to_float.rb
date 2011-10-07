class ChangeProjectsProbabilityToFloat < ActiveRecord::Migration
  def up
    change_column :projects, :probability, :decimal,
      :precision => 2, :scale => 1, :default => 0

    Project.unscoped.all.each do |project|
      project.probability = project.probability.to_f / 100
      project.save!
    end
  end

  def down
    change_column :projects, :probability, :integer
  end
end
