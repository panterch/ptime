class Milestone < ActiveRecord::Base
  belongs_to :milestone_type
  belongs_to :project, :autosave => true

  validates_presence_of :milestone_type
  attr_accessible :start, :reached, :milestone_type_id
end
