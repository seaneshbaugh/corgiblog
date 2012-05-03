default_run_options[:pty] = true
ssh_options[:forward_agent] = true

server "conneythecorgi.com", :web, :app, :db, :primary => true

set :application, "corgiblog"
set :user, "conneyth"
set :deploy_to, "/home/#{user}/#{application}/"
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
    run "echo -e 'PassengerEnabled On\\nPassengerAppRoot #{release_path}\\n' > #{release_path}/public/.htaccess"
  end

  task :symlink_uploads, :roles => :app do
    run "ls -s /#{user}/corgiblog_uploads #{release_path}/public/uploads"

  task :bundle_install, :roles => :app do
    run "cd #{release_path} && bundle install --path vendor/bundle"
  end

  task :precompile_assets, :roles => :app do
    run "cd #{release_path} and bundle exec rake assets:precompile"
  end

  after "deploy:finalize_update", "deploy:symlink_config"
  after "deploy:symlink_config", "deploy:add_htaccess"
  after "deploy:add_htaccess", "deploy:bundle_install"
  after "deploy:bundle_install", "deploy:precompile_assets"
end