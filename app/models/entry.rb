class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :project

  validates_presence_of :day, :project, :duration_hours, :task

  accepts_nested_attributes_for :task, :project, :user
  attr_accessible :day, :description, :start, :end, :task_id, :project_id,
    :user_id, :billable, :duration_hours

  # Incoming format HH:MM -> Save as minutes
  def duration_hours=(duration_hours)
    if duration_hours =~ /(^\d{1,3}:\d{1,2}$)|(^\d{1,3}$)/
      hours, minutes = duration_hours.split(":")
      self.duration = hours.to_i * 60 + minutes.to_i
    else
      self.duration = nil
    end
  end

  # Saved format minutes -> Return HH:MM
  def duration_hours
    (duration / 60).to_s + ":" + "%02i" % (duration % 60).to_s if duration
  end

  comma do
    project :shortname
    user :username
    day
    duration_hours
    self.task :name => 'Task'
    description
    billable
  end

end
