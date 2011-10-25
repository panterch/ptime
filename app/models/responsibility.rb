class Responsibility < ActiveRecord::Base

  has_paper_trail # versioning

  belongs_to :responsibility_type
  belongs_to :project, :autosave => true
  belongs_to :user

  validates_presence_of :responsibility_type
  attr_accessible :user_id, :responsibility_type_id

  scope :order_by_responsibility_type, includes('responsibility_type').order('responsibility_types.required DESC')

  default_scope where(:deleted_at => nil).order_by_responsibility_type

  def mark_as_deleted
    self.deleted_at = Time.now
    self.save
  end
end
