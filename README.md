# [conneythecorgi.com](http://conneythecorgi.com/)

This is the repository for Conney the Corgi's blog.

## Ruby Version

This application is intended to be run on Ruby 1.8.7-p173. Due to limitations of my current host Ruby 1.9 is not directly supported.

## Rails Version

This application uses Rails 3.2.13

## Required Gems

The following gems are required to run this application:

* rails (3.2.13)
* mysql2
* cancan
* devise
* exception_notification
* highline
* honeypot-captcha
* httparty
* kaminari
* paper_trail
* paperclip (~2.7)
* ransack
* sanitize
* simple_form
* yaml_db
* coffee-rails
* jquery-rails
* twitter-bootstrap-rails
* uglifier
* capistrano
* capistrano-ext
* mailcatcher
* quiet_assets
* capybara
* database_cleaner
* factory_girl_rails (~2.0)
* rspec-rails
* shoulda-matchers
* simplecov

## Local Development Installation

Clone the repository.

    $ git clone git@github.com:seaneshbaugh/corgiblog.git corgiblog

cd into the project directory. If you are using RVM you will be asked to trust the rvmrc. If you don't have ruby-1.8.7-p173 already you will want to install it before doing this.

    $ cd portfolio

Install the necessary gems.

    $ bundle install

Create the databases.

    $ rake db:create:all

Add the database tables.

    $ rake db:migrate
    $ RAILS_ENV=test rake db:migrate

Seed the database.

    $ rake db:seed

## Contacts

* [Sean Eshbaugh](mailto:seaneshbaugh@gmail.com)
