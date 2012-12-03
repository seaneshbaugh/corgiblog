set_default(:mysql_host, 'localhost')
set_default(:mysql_user) { Capistrano::CLI.ui.ask('MySQL User: ') }
set_default(:mysql_password) { Capistrano::CLI.password_prompt('MySQL Password: ') }
set_default(:mysql_database) { "#{user}_#{application}_#{rails_env}" }

namespace :mysql do
  desc 'Generate the database.yml configuration file.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template 'mysql.yml.erb', "#{shared_path}/config/database.yml"
  end
  after 'deploy:setup', 'mysql:setup'

  desc 'Symlink the database.yml file.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after 'deploy:finalize_update', 'mysql:symlink'
end
