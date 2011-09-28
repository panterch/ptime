class Project < ActiveRecord::Base
  belongs_to :project_state
  has_many :tasks, :dependent => :destroy
  has_many :accountings, :dependent => :destroy
  has_many :entries
  has_many :milestones, :dependent => :destroy, :order => :milestone_type_id

  PROBABILITIES = (0..10).map { |n| n.to_f/10 }.freeze

  accepts_nested_attributes_for :tasks, :reject_if => lambda { |task| task[:name].blank? }
  accepts_nested_attributes_for :project_state
  accepts_nested_attributes_for :milestones

  validates_presence_of :shortname, :description, :start, :end,
    :project_state, :wage

  validates_format_of :shortname, :with => /^\w{3}-\d{3}$/

  validates_inclusion_of :probability, :in => Project::PROBABILITIES

  attr_accessible :shortname, :description, :start, :end, :inactive,
    :state, :task_ids, :tasks_attributes, :project_state_id,
    :project_state_attributes, :probability, :wage, :rpl,
    :milestone_ids, :milestones_attributes

  default_scope where(:deleted_at => nil)

  scope :active, where(:inactive => false)

  def set_default_tasks
    APP_CONFIG['default_tasks'].each do |task_name|
      self.tasks.build(:name => task_name)
    end
  end

  def set_default_milestones
    MilestoneType.all.each do |milestone_type|
      self.milestones.build(:milestone_type_id => milestone_type.id)
    end
  end

  # Mark record and related collections as deleted
  def mark_as_deleted
    Project.transaction do
      self.deleted_at = Time.now
      self.save

      self.entries.each do |entry|
        entry.mark_as_deleted
      end
      self.tasks.each do |task|
        task.mark_as_deleted
      end
      self.milestones.each do |milestone|
        milestone.mark_as_deleted
      end
      self.accountings.each do |accounting|
        accounting.mark_as_deleted
      end
    end
  end
end
