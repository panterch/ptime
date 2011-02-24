class Task < ActiveRecord::Base
  belongs_to :project, :autosave => true

  attr_accessible :name, :estimate, :project_id
end
