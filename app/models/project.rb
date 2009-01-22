class Project < ActiveRecord::Base
  validates_presence_of :description
  validates_uniqueness_of :description

  has_many :tasks, :order => :position
  has_many :entries

  has_many :engagements
  has_many :users, :through => :engagements
  has_many :admins, :source => :user, :through => :engagements,
           :conditions => 'engagements.role = 1'

  # adds count emptu new tasks to the entry
  def add_empty_tasks(count = 10)
    (1..count).each { self.tasks << Task.new }
  end

  # sums all time booked on current project
  def total_time_used
    entries.inject(0) { |sum, e| sum + e.duration }
  end

  # sums all time estimated on current project
  def total_time_estimated
    tasks.inject(0) { |sum, t| sum + (t.estimation || 0) }
  end

  # calculates how many percent of the estimated time were
  # already used
  def percent_time_used
    percent = 0;
    if 0 < (estimated = total_time_estimated)
      percent = total_time_used / estimated * 100.0
    end
    percent
  end

  # this method builds a hash using the task ids as keys
  # and the time spent on each task as values. Time spent
  # on no specific task is mapped under the key nil.
  def time_used_per_task
    # compute only once, chace values in instacne variable
    if !@time_used_per_task
      @time_used_per_task = { nil => 0}
      entries.each do |e|
        @time_used_per_task[e.task_id] = e.duration +
          (@time_used_per_task[e.task_id] || 0)
      end
    end
    # entries could be booked on a task that was rendered
    # empty in the meantime. Double check tasks against keys
    @time_used_per_task.keys.each do |tid|
      task = tasks.detect { |t| tid == t.id }
      next if task == nil
      next unless 1 > task.name.length
      @time_used_per_task[nil] += @time_used_per_task[tid]
      @time_used_per_task[tid] = 0
    end
    @time_used_per_task
  end

  # sums the total time that was already billed
  def total_time_billed
    self.total_time_used * 0.4
  end

  def is_admin(user)
    admins.include? user
  end


  

end
