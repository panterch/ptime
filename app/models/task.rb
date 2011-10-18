class Task < ActiveRecord::Base
  belongs_to :project, :autosave => true

  attr_accessible :name, :estimate, :active, :project_id, :billable_by_default

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
end
