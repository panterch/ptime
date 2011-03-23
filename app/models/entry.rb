class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :project

  validates_presence_of :day, :project, :duration_hours, :task

  accepts_nested_attributes_for :task, :project, :user
  attr_accessible :day, :description, :start, :end, :task_id, :project_id,
    :user_id, :billable, :duration_hours

  # Incoming format HH:MM -> Save as minutes
  # FIXME: @seeb: Normally a validates_format_of could take care of the format
  # checking. But since this is a virtual attribute, the check will take place
  # after this setter is run. Is it therefore ok to check in an if statement in
  # the setter?
  def duration_hours=(duration_hours)
    if duration_hours =~ /(^\d{1,2}:\d{1,2}$)|(^\d{1,2}$)/
      hours, minutes = duration_hours.split(":")
      self.duration = hours.to_i * 60 + minutes.to_i
    end
  end

  # Saved format minutes -> Return HH:MM
  def duration_hours
    (duration / 60).to_s + ":" + (duration % 60).to_s if duration
  end

  comma do
    project :shortname
    user :username
    day
    duration_hours
    task :name=>'Task'
  end

end
