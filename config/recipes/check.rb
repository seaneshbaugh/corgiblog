namespace :check do
  desc 'Make sure local git is in sync with remote.'
  task :revision, :roles => :web do
    unless `get rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "FATAL: HEAD is not the same as origin/#{branch}"
      puts 'Run `git push` to sync changes.'
      exit
    end
  end

  before 'deploy', 'check:revision'
  before 'deploy:migrations', 'check:revision'
  before 'deploy:cold', 'check:revision'
end