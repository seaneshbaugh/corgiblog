namespace :db do
  desc 'Create the database'
  task :create do
    on roles(:db), in: :sequence, wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:create'
        end
      end
    end
  end

  desc 'Drop the database'
  task :drop do
    on roles(:db), in: :sequence, wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:drop'
        end
      end
    end
  end

  desc 'Truncate the database tables'
  task :truncate do
    on roles(:db), in: :sequence, wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:truncate'
        end
      end
    end
  end

  desc 'Remigrate the database'
  task :remigrate do
    on roles(:db), in: :sequence, wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:remigrate'
        end
      end
    end
  end

  desc 'Seed the database'
  task :seed do
    on roles(:db), in: :sequence, wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed_fu'
        end
      end
    end
  end

  desc 'Clean and then seed the database'
  task :reseed do
    on roles(:db), in: :sequence, wait: 5 do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:reseed'
        end
      end
    end
  end
end
