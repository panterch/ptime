require 'csv'

class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :project

  # TODO: Check presence of :task
  validates_presence_of :day, :project, :duration_hours

  accepts_nested_attributes_for :task, :project, :user
  attr_accessible :day, :description, :start, :end, :task_id, :project_id,
    :user_id, :billable, :duration_hours

  # Incoming format HH:MM -> Save as minutes
  def duration_hours=(duration_hours)
    hours, minutes = duration_hours.split(":")
    self.duration = hours.to_i * 60 + minutes.to_i
  end

  # Saved format minutes -> Return HH:MM
  def duration_hours
    (duration / 60).to_s + ":" + (duration % 60).to_s if duration
  end

end
