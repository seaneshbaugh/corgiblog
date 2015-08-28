namespace :test do
  Rails::TestTask.new(presenters: 'test:prepare') do |t|
    t.pattern = 'test/presenters/**/*_test.rb'
  end
end

Rake::Task[:test].enhance ['test:presenters']
