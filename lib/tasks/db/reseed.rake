namespace :db do
  desc 'Clean and then seed the database'
  task reseed: :environment do
    Rake::Task['db:truncate'].invoke

    Rake::Task['db:seed_fu'].invoke
  end
end
