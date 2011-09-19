# Import users
(1..10).each do |num|
  User.create!(:username => "admin_#{num}", 
               :password => 'admin_goodness', 
               :email => "admin_mail_#{num}@example.com") do |user|
    user.admin=true
  end
  User.create!(:username => "user#{num}", :password => 'let_me_in', 
               :email => "mail_#{num}@example.com")
end


# Import project states
project_states = ["offered", "won", "running", "closed", "lost", 
  "closing", "permanent"]

project_states.each do |project_state|
  p = ProjectState.new
  p.name = project_state
  p.save!
end


# Import demo projects
project_states_count = ProjectState.all.count
(1..10).each do |num|
  rnd_project_state = ProjectState.all[rand(project_states_count)]
  Project.create!(:shortname => "prj-%03d" % num,
                  :description => "description #{num}",
                  :inactive => [true,false].shuffle.shift,
                  :project_state_id => rnd_project_state.id,
                  :start => Date.today, 
                  :end => Date.today) do |project|
    (1..10).each do |project_id|
      Task.create!(:name => "task_#{num}", :project_id => project_id)
    end
  end
end

# Import accountings for the first project

# Cash in positions
project_id = Project.first.id
(1..5).each do |num|
  p = Accounting.new
  p.description = "position description #{num}"
  p.amount = rand(100000)
  p.valuta = Date.today - rand(20)
  p.project_id = project_id
  p.sent = [true,false].shuffle.shift
  p.payed = [true,false].shuffle.shift
  p.link = "http://link.to.position.#{num}"
  p.save!
end

# Cash out positions
project_id = Project.first.id
(1..5).each do |num|
  p = Accounting.new
  p.description = "position description #{num}"
  p.amount = - rand(100000)
  p.valuta = Date.today - rand(20)
  p.project_id = project_id
  p.sent = [true,false].shuffle.shift
  p.payed = [true,false].shuffle.shift
  p.link = "http://link.to.position.#{num}"
  p.save!
end

# Milestone Types
['offer submission', 'offer presentation', 'sales debriefing', 'project kick-off', 'production start', 'final project report', 'project review', 'project end'].each do |milestone|
  m = MilestoneType.new
  m.name = milestone
  m.save!
end
