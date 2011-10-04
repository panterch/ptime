Factory.define :post do |f|
  f.title 'Post title'
  f.body 'Post body'
end

Factory.define :user do |f|
  f.username 'user'
  f.sequence(:email) { |n| "user_#{n}@example.com" }
  f.password 'good_password'
  f.admin false
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
  f.shortname 'abc-123'
  f.description 'An awesome project'
  f.inactive false
  f.association :project_state, :factory => :project_state
  f.tasks { |task| [task.association(:task)] }
  f.start Date.parse('2011-01-01')
  f.end Date.parse('2011-01-03')
  f.wage 90
  f.responsibilities { |res| [res.association(:scrum_master_responsibility),
    res.association(:product_owner_responsibility)] }
end

Factory.define :project_inactive, :parent => :project do |f|
  f.inactive true
end

Factory.define :entry do |f|
  f.day Date.parse('2011-01-01')
  f.start Time.parse('2011-01-01 01:00')
  f.end Time.parse('2011-01-01 02:00')
  f.duration_hours "01:00"
  f.association :user, :factory => :user
  f.association :project, :factory => :project
  f.association :task, :factory => :task
  f.description "It's an entry."
  f.billable true
end

Factory.define :accounting do |f|
  f.description 'some account position'
  f.amount '3299'
  f.valuta Date.parse('2011-09-01 02:00')
  f.association :project, :factory => :project
end

Factory.define :milestone do |f|
  f.association :milestone_type, :factory => :milestone_type
  f.association :project, :factory => :project
end

Factory.define :responsibility do |f|
  f.association :responsibility_type, :factory => :responsibility_type
  f.association :project, :factory => :project
end

Factory.define :milestone_type do |f|
  f.name 'project kick-off'
end

Factory.define :responsibility_type do |f|
  f.name 'techlead'
end

Factory.define :scrum_master_responsibility_type, :class => ResponsibilityType do |f|
  f.name 'scrum master'
end

Factory.define :product_owner_responsibility_type, :class => ResponsibilityType do |f|
  f.name 'product owner'
end

Factory.define :scrum_master_responsibility, :class => Responsibility do |f|
  f.association :responsibility_type, :factory => :scrum_master_responsibility_type
  f.association :user, :factory => :user
end

Factory.define :product_owner_responsibility, :class => Responsibility do |f|
  f.association :responsibility_type, :factory => :product_owner_responsibility_type
  f.association :user, :factory => :user
end
