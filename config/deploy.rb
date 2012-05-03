default_run_options[:pty] = true
ssh_options[:forward_agent] = true

server "conneythecorgi.com", :web, :app, :db, :primary => true

set :application, "corgiblog"
set :user, "conneyth"
set :deploy_to, "/home/#{user}/this_is_a_test/#{application}/"
#set :deploy_via, :remote_cache
set :normalize_asset_timestamps, false
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:seaneshbaugh/#{application}.git"
set :branch, "master"

after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_config, :roles => :app do
    # I dunno if this is a good idea. But I don't want my database config in my repository.
    run "ln -s /home/#{user}/database.yml #{release_path}/config/database.yml"
  end

  task :add_htaccess, :roles => :app do
    run "touch #{release_path}/public/.htaccess"
    run "echo -e 'PassengerEnabled On\\nPassengerAppRoot #{release_path}' > #{release_path}/public/.htaccess"
  end

  after "deploy:finalize_update", "deploy:symlink_config"
  after "deploy:symlink_config", "deploy:add_htaccess"
end