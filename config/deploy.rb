set :stages, %w(production)
set :default_stag, 'production'

require 'bundler/capistrano'
require 'capistrano/ext/multistage'

#TODO: Make recipes for deployment
#load 'config/recipes/base'
#load 'config/recipes/check'
#load 'config/recipes/db'
#load 'config/recipes/mysql'

set :application, 'corgiblog'
set :user, 'conneyth'
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, 'git'
set :repository, 'git@github.com:seaneshbaugh/corgiblog.git'
set :scm_verbose, true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy', 'deploy:cleanup'
