class Milestone < ActiveRecord::Base
  belongs_to :milestone_type
  belongs_to :project, :autosave => true

  has_attached_file :document

  validates_presence_of :milestone_type
  attr_accessible :start, :reached, :milestone_type_id, :document, :url

  default_scope where(:deleted_at => nil)

  def destroy_with_mark
    self.deleted_at = Time.now
    self.save
  end

  alias_method_chain :destroy, :mark
end
