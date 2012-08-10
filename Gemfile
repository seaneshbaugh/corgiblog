source 'https://rubygems.org'

gem 'rails', '3.2.7'
gem 'mysql2'
gem 'cancan'
gem 'devise'
gem 'highline'
gem 'httparty'
gem 'jquery-rails'
gem 'kaminari'
gem 'paper_trail'

if RUBY_VERSION.match /1.8.\d/
  gem 'paperclip', '~> 2.7'
else
  gem 'paperclip'
end

gem 'ransack'
gem 'simple_form'
gem 'yaml_db'

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'twitter-bootstrap-rails'
  gem 'uglifier'
end

group :development do
  gem 'capistrano-ext'
  gem 'mailcatcher'
  gem 'quiet_assets'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'

  if RUBY_VERSION.match /1.8.\d/
    gem 'factory_girl', '~> 2.0'
  else
    gem 'factory_girl_rails'
  end

  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov', :require => false
end