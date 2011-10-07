class Milestone < ActiveRecord::Base
  belongs_to :milestone_type
  belongs_to :project, :autosave => true

  validates_presence_of :milestone_type
  attr_accessible :start, :reached, :milestone_type_id

  default_scope where(:deleted_at => nil)

  def destroy_with_mark
    self.deleted_at = Time.now
    self.save
  end

  alias_method_chain :destroy, :mark
end
