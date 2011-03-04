Factory.define :post do |f|
  f.title 'Post title'
  f.body 'Post body'
end

Factory.define :user do |f|
  f.username 'admin'
  f.email 'admin@panter.ch'
  f.password 'good_password'
end

Factory.define :project_state do |f|
  f.name "offered"
end

Factory.define :project do |f|
  f.name 'First project'
  f.description 'An awesome project'
  f.inactive false
  f.project_state_id 1
  f.start Date.parse('2011-01-01')
  f.end Date.parse('2011-01-03')
end

Factory.define :task do |f|
  f.name 'First task'
  f.inactive false
  f.estimate 5
end
