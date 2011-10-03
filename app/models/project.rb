class Project < ActiveRecord::Base
  belongs_to :project_state
  has_many :tasks, :dependent => :destroy
  has_many :accountings, :dependent => :destroy
  has_many :entries
  has_many :milestones, :dependent => :destroy, :order => :milestone_type_id
  has_many :responsibilities, :dependent => :destroy, :order => :responsibility_type_id

  PROBABILITIES = (0..10).map { |n| n.to_f/10 }.freeze

  accepts_nested_attributes_for :tasks, :reject_if => lambda { |task| task[:name].blank? }
  accepts_nested_attributes_for :project_state
  accepts_nested_attributes_for :milestones
  accepts_nested_attributes_for :responsibilities

  validates_presence_of :shortname, :description, :start, :end,
    :project_state, :wage

  validates_format_of :shortname, :with => /^\w{3}-\d{3}$/

  validates_inclusion_of :probability, :in => Project::PROBABILITIES

  validate :needs_scrum_master_and_product_owner

  attr_accessible :shortname, :description, :start, :end, :inactive,
    :state, :task_ids, :tasks_attributes, :project_state_id,
    :project_state_attributes, :probability, :wage, :rpl,
    :milestone_ids, :milestones_attributes,
    :responsibility_ids, :responsibilities_attributes

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

  def set_default_responsibilities
    ResponsibilityType.all.each do |responsibility_type|
      self.responsibilities.build(:responsibility_type_id => responsibility_type.id)
    end
  end

  # Mark record and related collections as deleted
  def destroy_with_mark
    Project.transaction do
      self.deleted_at = Time.now
      self.save

      self.entries.each do |entry|
        entry.destroy
      end
      self.tasks.each do |task|
        task.destroy
      end
      self.milestones.each do |milestone|
        milestone.destroy
      end
      self.accountings.each do |accounting|
        accounting.destroy
      end
      self.responsibilities.each do |responsibility|
        responsibility.mark_as_deleted
      end
    end
  end


  private

  def needs_scrum_master_and_product_owner
    responsibility_names = {}
    responsibilities.each do |r|
      if not r.user.nil?
        responsibility_names[r.responsibility_type.name] = r.user_id
      end
    end
    if not responsibility_names.has_key?('scrum master') or
       not responsibility_names.has_key?('product owner')
      errors.add(:base, 'needs a scrum master and a product owner.')
    end
  end

  alias_method_chain :destroy, :mark
end
