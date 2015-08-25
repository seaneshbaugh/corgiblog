namespace :deploy do
  %w(start stop restart).each do |command|
    desc "#{command.capitalize} Unicorn server."
    task command => [:set_rails_env] do
      on roles(:app), in: :sequence, wait: 5 do
        execute "/etc/init.d/#{fetch(:application)}_unicorn #{command}"
      end
    end
  end
  after :publishing, :restart
end
