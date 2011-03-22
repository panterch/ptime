Factory.define :post do |f|
  f.title 'Post title'
  f.body 'Post body'
end

Factory.define :user do |f|
  f.username 'admin'
  f.sequence(:email) { |n| "admin_#{n}@example.com" }
  f.password 'good_password'
end

Factory.define :project_state do |f|
  f.name "offered"
end

Factory.define :task do |f|
  f.name 'First task'
  f.inactive false
  f.estimate 5
end

Factory.define :project do |f|
  f.shortname 'First project'
  f.description 'An awesome project'
  f.inactive false
  f.association :project_state, :factory => :project_state
  f.tasks { |task| [task.association(:task)] }
  f.start Date.parse('2011-01-01')
  f.end Date.parse('2011-01-03')
end

Factory.define :project_inactive, :parent => :project do |f|
  f.inactive true
end

Factory.define :entry do |f|
  f.day Date.parse('2011-01-01')
  f.start Date.parse('2011-01-01 01:00')
  f.end Date.parse('2011-01-01 02:00')
  f.duration_hours "01:00"
  f.association :user, :factory => :user
  f.association :project, :factory => :project
  f.association :task, :factory => :task
  f.description "It's an entry, you know?"
  f.billable true
end
