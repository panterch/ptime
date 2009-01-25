class Task < ActiveRecord::Base

  belongs_to :project
  acts_as_list :scope => :project_id

  validates_presence_of :name
  validates_numericality_of :estimation, :allow_blank => true

end
