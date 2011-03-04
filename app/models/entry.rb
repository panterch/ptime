class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :project

  accepts_nested_attributes_for :task, :project, :user
  attr_accessible :description, :start, :end, :task_id, :project_id, :user_id
end
