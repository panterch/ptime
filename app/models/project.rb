class Project < ActiveRecord::Base
  has_many :tasks
  accepts_nested_attributes_for :tasks

  validates_presence_of :name, :description, :start, :end
  attr_accessible :name, :description, :start, :end, :inactive, :task_ids,
                  :tasks_attributes
end
