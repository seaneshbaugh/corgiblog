set :tumblr_blog_url, 'conneythecorgi.tumblr.com'
set :tumblr_api_key, Capistrano::CLI.ui.ask('Tumblr API Key: ')

namespace :tmblr do
  desc 'Generate the tumblr.rb initializer file.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config/initializers"
    template 'tumblr.rb.erb', "#{shared_path}/config/initializers/tumblr.rb"
  end
  after 'deploy:setup', 'tumblr:setup'

  desc 'Symlink the tumblr.rb initializer file.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/initializers/tumblr.rb #{release_path}/config/initializers/tumblr.rb"
  end
  after 'deploy:finalize_update', 'tumblr:symlink'
end
