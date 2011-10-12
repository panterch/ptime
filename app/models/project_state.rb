class ProjectState < ActiveRecord::Base
  attr_accessible :name, :position
  validates_presence_of :name

  default_scope order(:position)

end
