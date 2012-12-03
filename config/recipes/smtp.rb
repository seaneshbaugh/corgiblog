set_default(:smtp_user_name) { Capistrano::CLI.ui.ask('SMTP User Name (your email address): ') }
set_default(:smtp_password) { Capistrano::CLI.password_prompt('SMTP Password (your email password): ') }

namespace :smtp do
  desc 'Generate the smtp.yml configuration file.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template 'smtp.yml.erb', "#{shared_path}/config/smtp.yml"
  end
  after 'deploy:setup', 'smtp:setup'

  desc 'Symlink the smtp.yml file.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/smtp.yml #{release_path}/config/smtp.yml"
  end
  after 'deploy:finalize_update', 'smtp:symlink'
end
