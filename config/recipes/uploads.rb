namespace :uploads do
  desc 'Create the upload directory if it does not exist.'
  task :setup do
    run "mkdir -p #{shared_path}/uploads #{release_path}/public/uploads && chmod g+w #{shared_path}/uploads"
  end
  after 'deploy:symlink', 'uploads:setup'

  desc 'Creates symlink to shared uploads directory.'
  task :symlink do
    run "rm -rf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  after 'uploads:setup', 'uploads:symlink'
end
