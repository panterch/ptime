class Project < ActiveRecord::Base

  has_paper_trail # versioning

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

  validates_uniqueness_of :shortname

  validates_inclusion_of :probability, :in => Project::PROBABILITIES

  validate :validates_required_responsibilities

  validate :validates_probability_constraints

  attr_accessible :shortname, :description, :start, :end, :inactive, :active,
    :state, :task_ids, :tasks_attributes, :project_state_id,
    :project_state_attributes, :probability, :wage, :rpl,
    :milestone_ids, :milestones_attributes,
    :responsibility_ids, :responsibilities_attributes,
    :external, :note, :current_worktime

  attr_accessor :active # Virtual field which will update the value of inactive

  before_save :update_inactive

  default_scope where(:deleted_at => nil)

  scope :active, where(:inactive => false)

  # Scopes needed for 'meta_search'
#  scope :sort_by_overdue_amount_asc, all.sort_by { |p| p.overdue_amount }
  #scope :sort_by_overdue_amount_desc

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

  alias_method_chain :destroy, :mark

  # Cumulated time of all entries(minutes) and expected_remaining_work(hours)
  def total_time
    minutes_to_human_readable_time(entries.internal.sum(:duration) + expected_remaining_work * 60)
  end

  # Cumulated time of all billable entries
  def time_billable
    minutes_to_human_readable_time(entries.internal.where(
      :billable => true).sum(:duration))
  end

  # Cumulated time of all entries
  def burned_time
    minutes_to_human_readable_time(entries.internal.sum :duration)
  end

  def expected_remaining_work
    #rpl ? rpl.to_s + "h" : "0h"
    to_burn = current_worktime - (entries.internal.sum(:duration) / 60)
  end

  # Sum all positive accounting positions
  def budget
    accountings.where(:positive => true).sum :amount
  end

  def expected_return
    budget - past_work + external_cost - expected_work
  end

  def current_expected_return
    budget - past_work + external_cost - current_expected_work
  end

  def current_internal_cost
    (entries.internal.sum(:duration) / 60.0) * wage
  end

  def external_cost
    accountings.where(:positive => false).sum :amount
  end

  def expected_work
    (rpl || 0) * wage
  end

  def current_expected_work
    (current_worktime || 0) * wage
  end

  def expected_profitability
    if budget != 0
      100.0 * expected_return / budget
    else
      0.0
    end
  end

  def current_expected_profitability
    if budget != 0
      100.0 * current_expected_return / budget
    else
      0.0
    end
  end

  def overdue_amount
    accountings.where("valuta <= ?", Time.now).
      where(:payed => false, :sent => true, :positive => true).sum :amount
  end

  def volume
    accountings.where(:positive => true).sum :amount
  end

  def active
    @active = !inactive
  end

  def active=(value)
    value == "1" ? @active = true : @active = false
  end

  private

  def past_work
    entries.internal.sum(:duration) / 60.0 * wage
  end

  def rpl_or_zero
    rpl ? rpl : 0
  end

  def minutes_to_human_readable_time(minutes)
    (minutes / 60).to_s + ":" + "%02i" % (minutes % 60).to_s
  end

  def validates_required_responsibilities
    self.responsibilities.each do |r|
      if r.user.nil? and r.responsibility_type.required
        errors.add(:base,
                   "Needs a #{r.responsibility_type.name} responsibility")
      end
    end
  end

  # TODO: This needs to be refactored
  def validates_probability_constraints
    if project_state
      if (project_state.name == 'lead') && (probability >= 1.0)
        errors.add(:base,
                   "Probability of #{probability} is not allowed for the project state #{project_state.name}")
      end

      if (project_state.name == 'offered') && (probability >= 1)
        errors.add(:base,
                   "Probability of #{probability} is not allowed for the project state #{project_state.name}")
      end

      if (project_state.name == 'won') && (probability < 1)
        errors.add(:base,
                   "Probability of #{probability} is not allowed for the project state #{project_state.name}")
      end

      if (project_state.name == 'running') && (probability < 1)
        errors.add(:base,
                   "Probability of #{probability} is not allowed for the project state #{project_state.name}")
      end

      if (project_state.name == 'lost') && (probability > 0)
        errors.add(:base,
                   "Probability of #{probability} is not allowed for the project state #{project_state.name}")
      end

      if (project_state.name == 'closing') && (probability < 1)
        errors.add(:base,
                   "Probability of #{probability} is not allowed for the project state #{project_state.name}")
      end

      if (project_state.name == 'permanent') && (probability < 1)
        errors.add(:base,
                   "Probability of #{probability} is not allowed for the project state #{project_state.name}")
      end
    end
  end

  private

  # Used for cases where the checkbox needs to be titled active
  def update_inactive
    unless @active.nil?
      self.inactive = !@active
      logger.debug("Is model valid: #{valid?}")
    end
  end


end
