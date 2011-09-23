class Milestone < ActiveRecord::Base
  belongs_to :milestone_type
  belongs_to :project
  before_create :propagate_reached_flag

  validates_presence_of :project, :milestone_type
  attr_accessible :reached, :milestone_type_id

  default_scope where(:deleted_at => nil)

  def propagate_reached_flag
    past_milestone = Milestone.where("project_id = ?", self.project.id).order('created_at DESC').first
    if past_milestone
      past_milestone.update_attribute(:reached, true) if self.reached
    end
    self.reached = false
    true
  end

  def mark_as_deleted
    self.deleted_at = Time.now
    self.save
  end
end
