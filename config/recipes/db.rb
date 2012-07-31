namespace :db do
  desc 'Load the seed data from db/seeds.rb.'
  task :seed, :roles => :db do
    run "cd #{current_path} && bundle exec rake RAILS_ENV=#{rails_env} db:seed"
  end
end
