class Task < ActiveRecord::Base

  belongs_to :project
  acts_as_list :scope => :project_id

  validates_presence_of :name
  validates_numericality_of :estimation, :allow_blank => true

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
