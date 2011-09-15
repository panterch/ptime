class CreateProjectMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.integer :project_id, :null => false
      t.integer :milestone_type_id, :null => false
      t.boolean :reached, :default => false

      t.timestamps
    end

    create_table :milestone_types do |t|
      t.string :name, :null => false

      t.timestamps
    end

    ['offer submission', 'offer presentation', 'sales debriefing', 'project kick-off', 'production start', 'final project report', 'project review', 'project end'].each do |milestone|
      m = MilestoneType.new
      m.name = milestone
      m.save!     
    end

  end

  def self.down
    drop_table :milestone_types
    drop_table :milestones
  end
end
