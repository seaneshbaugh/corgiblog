server 'conneythecorgi.com', :app, :web, :db, :primary => true

set :branch, 'master'
set :rails_env, 'production'
set :deploy_to, "/home/#{user}/#{application}/#{rails_env}"
set :domain, 'conneythecorgi.com'

namespace :deploy do
  desc 'Generate .htaccess file for Passenger.'
  task :htaccess, :roles => :app do
    template '.htaccess.erb', "#{release_path}/public/.htaccess"
  end
  after 'deploy:finalize_update', 'deploy:htaccess'
end
