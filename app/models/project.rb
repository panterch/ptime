class Project < ActiveRecord::Base
  has_one :project_state
  has_many :tasks, :dependent => :destroy

  accepts_nested_attributes_for :tasks, :project_state, :reject_if => lambda { |task| task[:name].blank? }

  validates_presence_of :shortname, :description, :start, :end#, :project_state

  attr_accessible :shortname, :description, :start, :end, :inactive, :state,
    :task_ids, :tasks_attributes, :project_state_id, :project_state_attributes
end
