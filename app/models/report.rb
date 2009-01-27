class Report < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_presence_of :project_id

  def entries
    return [] unless start_date

    condition = 'date >= ? AND date <= ?'
    args = Array.new
    args << start_date
    args << end_date

    condition << ' AND project_id = ?'
    args << project_id

    conditions = args.insert(0,condition)

    Entry.find(:all, :conditions => conditions) 
  end

  private

    def check_permission
      unless Project.find(@project_id).users.include? user
        raise SecurityError
      end
    end

end
