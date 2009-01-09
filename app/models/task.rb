class Task < ActiveRecord::Base

  belongs_to :project
  acts_as_list :scope => :project_id

  # before save asserts some constraints before each record is written
  def before_save
    # do not allow tasks with estimation but no description
    if estimation and 1 > name.length
      self.estimation = nil
    end
    # when no estimation is given, set it to 0
    if 0 < name.length and nil == estimation
      self.estimation = 0
    end
  end

  @@default_tasks =
      [ 'Project Lead', 
      'Implementation', 
      'Documentation',
      'Change Request',
      'Bugfix',
      'Meeting',
      '','','',''].collect { |d| Task.new( :name => d ) }

  def self.default_tasks
    @@default_tasks
  end
  
end
