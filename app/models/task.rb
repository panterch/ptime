class Task < ActiveRecord::Base
  belongs_to :project, :autosave => true

  attr_accessible :name, :estimate, :inactive, :project_id

  # :active scope with optional boolean argument
  scope :active, lambda { 
    |*args|
    where(:inactive => ( args.first.nil? ? false: !args.first)) 
  }

  scope :with_project_id, lambda { |id| where(:project_id => id) }
end
