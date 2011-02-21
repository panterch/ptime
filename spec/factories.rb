Factory.define :post do |f|
  f.title 'Post title'
end

Factory.define :user do |f|
  f.username 'admin'
  f.email 'admin@panter.ch'
  f.password 'good_password'
end
