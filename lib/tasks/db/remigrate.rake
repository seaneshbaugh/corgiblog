namespace :db do
  desc 'Drop, create, and then migrate the database'
  task remigrate: :environment do
    Rake::Task['db:drop'].invoke

    Rake::Task['db:create'].invoke

    Rake::Task['db:migrate'].invoke
  end
end
