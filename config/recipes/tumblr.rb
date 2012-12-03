set :tumblr_blog_url, 'conneythecorgi.tumblr.com'
set_default(:tumblr_api_key) { Capistrano::CLI.ui.ask('Tumblr API Key: ') }

namespace :tumblr do
  desc 'Generate the tumblr.yml configuration file.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template 'tumblr.yml.erb', "#{shared_path}/config/tumblr.yml"
  end
  after 'deploy:setup', 'tumblr:setup'

  desc 'Symlink the tumblr.yml file.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/tumblr.yml #{release_path}/config/tumblr.yml"
  end
  after 'deploy:finalize_update', 'tumblr:symlink'
end
