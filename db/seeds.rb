# Import active users from ptime with initial pwd 'welcome'
users = { 'aml' => 'aml@panter.ch', 
    'dan' => 'dan@panter.ch',
    'dil' => 'dil@panter.ch', 
    'geo' => 'geo@panter.ch', 
    'koa' => 'koa@panter.ch',
    'maa' => 'maa@panter.ch', 
    'mir' => 'mizunzu@gmail.com',
    'pho' => 'pho@panter.ch', 
    'rob' => 'rob@panter.ch', 
    'seb' => 'seb@panter.ch',
    'sev' => 'sev@panter.ch', 
    'sym' => 'sym@panter.ch', 
    'tam' => 'tam@panter.ch', 
    'tpo' => 'tpo@panter.ch', 
    'tro' => 'tro@panter.ch',
    'uee' => 'unknown1@unknown.com'
}

users.each do |username, email|
  User.create!(:username => username, :password => 'welcome', :email => email)
end


# Import project states
project_states = ["offered", "won", "running", "closed", "lost", "closing",
  "permanent"]

project_states.each do |project_state|
  p = ProjectState.new
  p.name = project_state
  p.save!
end


# Import demo projects
Factory(:project)
