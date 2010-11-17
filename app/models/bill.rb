require 'csv'

class Bill < ActiveRecord::Base

  belongs_to :project
  belongs_to :user
  has_many   :entries, :order => :date

  # assert values in date rows
  def before_save
    self.start = Date.today unless self.start
    self.end =   Date.today unless self.end
  end

  # generates a name after creation (using the auto generated key)
  def after_create
    return if self.name
    logger.info "Bill #{self.id} created"
    self.name = self.project.description + ' ' + self.id.to_s
    save
  end


  # generates a csv representation of the current record
  def to_csv
    row = [ self.project.description, 
            self.name ]
    csv = CSV.generate_line(row) + "\n"
    self.entries.inject(csv) { |csv, e| csv + e.to_csv + "\n" }
  end

end
