class Task < ActiveRecord::Base

  ACTIVE_BY_DEFAULT = ["Project Management"]

  has_paper_trail # versioning

  belongs_to :project, :autosave => true

  attr_accessible :name, :estimate, :active, :project_id, :billable_by_default

  after_initialize :mark_active

  # :active scope with optional boolean argument
  scope :active, lambda {
    |*args|
    where(:active => ( args.first.nil? ? false: !args.first))
  }

  default_scope where(:deleted_at => nil)

  scope :active, where(:active => true)

  scope :with_project_id, lambda { |id| where(:project_id => id) }

  def destroy_with_mark
    self.deleted_at = Time.now
    self.save
  end

  alias_method_chain :destroy, :mark

  private

  # Marks active by default all tasks with names contained in the constant ACTIVE_BY_DEFAULT
  def mark_active
    if ACTIVE_BY_DEFAULT.include? self.name
      self.active = true
    end
  end
end
