class Accounting < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :description, :amount, :valuta, :project
  attr_accessible :description, :amount, :valuta, :project_id
end
