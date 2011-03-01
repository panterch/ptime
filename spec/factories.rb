Factory.define :post do |f|
  f.title 'Post title'
  f.body 'Post body'
end

Factory.define :user do |f|
  f.username 'admin'
  f.email 'admin@panter.ch'
  f.password 'good_password'
end

Factory.define :project do |f|
  Timecop.freeze(2011, 02, 01)
  f.name 'First project'
  f.description 'An awesome project'
  f.inactive false
  f.start Time.now
  f.end Time.now + 2.days
end

Factory.define :task do |f|
  f.name 'First task'
  f.estimate 5
end
