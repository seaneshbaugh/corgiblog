namespace :devise do
  desc 'Generate the devise.yml configuration file.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template 'devise.yml.erb', "#{shared_path}/config/devise.yml"
  end
  after 'deploy:setup', 'devise:setup'

  desc 'Symlink the devise.yml file.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/devise.yml #{release_path}/config/devise.yml"
  end
  after 'deploy:finalize_update', 'devise:symlink'
end
