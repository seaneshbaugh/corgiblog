# [conneythecorgi.com](http://conneythecorgi.com/)

This is the repository for Conney the Corgi's blog.

## Ruby Version

This application is intended to be run on Ruby 2.3.1.

## Rails Version

This application uses Rails 5.0.0.1.

## Local Development Installation

Clone the repository.

    $ git clone git@github.com:seaneshbaugh/corgiblog.git corgiblog

cd into the project directory. If you don't have ruby-2.3.1 already you will want to install it before doing this.

    $ cd corgiblog

Install the necessary gems.

    $ bundle install

Create the databases.

    $ rake db:create:all

Add the database tables.

    $ rails db:migrate
    $ RAILS_ENV=test rails db:migrate

Seed the database.

    $ rails db:seed_fu

## Running Locally

### Rails Server

    $ rails s

### RabbitMQ Server

    $ rabbitmq-server

### RabbitMQ Job Processor

    $ bin/rabbitmq_job_processor -q contact start

    $ bin/rabbitmq_job_processor -q contact stop

### RabbitMQ Management

The RabbitMQ Management panel can be accessed at [localhost:15672](http://localhost:15672/). Username and password should be whatever is in your application.yml file. The default is "guest" and "guest".

## Contacts

* [Sean Eshbaugh](mailto:seaneshbaugh@gmail.com)
