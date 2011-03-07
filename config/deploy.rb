require 'bundler/capistrano'

set :application, "pan023"

role :app, "pan023.panter.ch"
role :web, "pan023.panter.ch"
role :db,  "pan023.panter.ch", :primary => true
set :rails_env, 'production'

set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :scm, :git
set :default_run_options, { :pty => true }
set :repository, "gitosis@git.panter.ch:panter_controlling.git"
set :ssh_options, {:forward_agent => true}
set :deploy_to, "/home/pan023/pan023.panter.ch"
set :user, "pan023"
set :use_sudo, false

task :update_config_links, :roles => [:app] do
  run "ln -sf #{shared_path}/config/* #{release_path}/config/"
end
after "deploy:update_code", :update_config_links

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy", "deploy:cleanup"
