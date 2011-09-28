class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :project
  before_save :save_duration

  validates_presence_of :day, :project, :task

  validate :duration_start_end_combination_must_be_valid
  validate :negative_time_spans_are_not_allowed
  validate :duration_hours_format

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
      @duration_hours_invalid = true
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

  def to_csv
    result = ''
    CSV::Writer.generate(result, ',') do |csv|
      csv << [self.project.shortname, self.user.username, self.day,
        self.duration_hours, self.task.name, self.description, self.billable]
    end
    result
  end


  private

  def save_duration
    self.duration = (self.end - self.start) / 60 if self.duration.nil?
    true
  end

  # Validates combination of duration and start/end values
  def duration_start_end_combination_must_be_valid
    if start.nil? and self.end.nil? and duration_hours.nil?
      errors.add(:base,
                 'Either a duration or a start -and end time are required.')
    elsif duration_hours.nil?
      if start.nil? and not self.end.nil?
        errors.add(:start, 'time is required.')
      elsif self.end.nil? and not start.nil?
        errors.add(:end, 'time is required.')
      end
    end
  end

  def negative_time_spans_are_not_allowed
    if (not start.nil? and not self.end.nil?) and start > self.end
      errors.add(:start, 'time cannot be after end time.')
    end
  end

  def duration_hours_format
    if @duration_hours_invalid
      errors.add(:duration_hours, 'format invalid.')
    end
  end

  # Generates CSV
  def self.csv(search_params = nil)
    csv = "User name, Day, Duration (hours), Task name, Description, Billable\n"
    Entry.search(search_params).all.each do |e|
      csv << e.to_csv
    end
    csv
  end
end
