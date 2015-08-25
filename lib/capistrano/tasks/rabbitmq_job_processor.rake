namespace :rabbitmq_job_processor do
  %w(start stop restart).each do |command|
    desc "#{command.capitalize} rabbitmq_job_processor process."
    task command do
      on roles(:app), in: :sequence, wait: 5 do
        execute "/etc/init.d/#{fetch(:application)}_rabbitmq_job_processor #{command}"
      end
    end
  end
end

namespace :deploy do
  after :publishing, 'rabbitmq_job_processor:restart'
end
