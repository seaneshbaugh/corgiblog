server 'conneythecorgi.com', :app, :web, :db, :primary => true

set :branch, 'master'
set :rails_env, 'production'
set :deploy_to, "/home/#{user}/#{application}/#{rails_env}"
set :domain, 'conneythecorgi.com'
