require 'csv'

class Entry < ActiveRecord::Base

  validates_presence_of :description, :date, :duration, :project_id, :user_id
  validates_numericality_of :duration

  # assure that the selected task really belongs to the selected project
  # (this could be caused by client malfunctions / races)
  def validate
    if self.task && self.project_id != self.task.project_id
      self.task = nil
      errors.add(:task, "Task does not belong to selected project")
    end
  end

  belongs_to :project
  belongs_to :task
  belongs_to :user
  belongs_to :bill

  # generates a csv representation of the current record
  def to_csv
    row = [ self.date, self.duration, self.project.description, 
            self.task ? self.task.name : '',
            self.user.name, self.description ]
    CSV.generate_line row
  end
  
end
