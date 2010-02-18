set :application, "ptime"

role :app, "ptime.panter.ch"
role :web, "ptime.panter.ch"
role :db,  "ptime.panter.ch", :primary => true
set :rails_env, 'production'

set :deploy_via, :remote_cache
set :scm, :git
set :repository,  "git://github.com/panter/ptime.git"
set :ssh_options, {:forward_agent => true}
set :deploy_to, "/home/ptime/ptime"
set :user, "ptime"
set :use_sudo,    false

task :update_config_links, :roles => [:app] do
  run "ln -sf #{shared_path}/config/* #{release_path}/config/"
end
after "deploy:update_code", :update_config_links

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
