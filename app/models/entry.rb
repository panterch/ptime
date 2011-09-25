class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :project
  before_save :save_duration

  validates_presence_of :day, :project, :task
  validates_presence_of :duration_hours, 
    :if => lambda { |entry| entry.start.nil? and entry.end.nil? }
  validates_presence_of :start, :end,
    :if => lambda { |entry| entry.duration_hours.nil? }

  accepts_nested_attributes_for :task, :project, :user
  attr_accessible :day, :description, :start, :end, :task_id, :project_id,
    :user_id, :billable, :duration_hours

  default_scope where(:deleted_at => nil)

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

  def mark_as_deleted
    self.deleted_at = Time.now
    self.save
  end

  def save_duration
    self.duration = (self.end - self.start) / 60 if self.duration.nil?
  end
end
