# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

PanterControlling::Application.load_tasks

task 'assets:precompile:nondigest' do
  #run "nice -19 #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile:nondigest"
  echo "FOO"
end
