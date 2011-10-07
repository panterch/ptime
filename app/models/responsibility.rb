class Responsibility < ActiveRecord::Base
  belongs_to :responsibility_type
  belongs_to :project, :autosave => true
  belongs_to :user

  validates_presence_of :responsibility_type
  attr_accessible :user_id, :responsibility_type_id

  default_scope where(:deleted_at => nil)

  def mark_as_deleted
    self.deleted_at = Time.now
    self.save
  end
end
