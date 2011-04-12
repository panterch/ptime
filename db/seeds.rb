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
  Project.create!(:shortname => "project_#{num}",
                  :description => "description #{num}",
                  :inactive => [true,false].shuffle.shift,
                  :project_state_id => rnd_project_state.id,
                  :start => Date.today, 
                  :end => Date.today)
end
