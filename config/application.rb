require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Corgiblog
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += Dir[Rails.root.join('app', 'builders')]

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]

    config.autoload_paths += Dir[Rails.root.join('app', 'presenters', '{**}')]

    config.autoload_paths += Dir[Rails.root.join('app', 'services', '{**}')]

    config.autoload_paths += Dir[Rails.root.join('app', 'validators')]

    config.active_job.queue_adapter = :rabbitmq

    config.rabbitmq_connection_settings = {
      host: ENV['RABBIT_MQ_HOST'],
      port: ENV['RABBIT_MQ_PORT'].to_i,
      username: ENV['RABBIT_MQ_USERNAME'],
      password: ENV['RABBIT_MQ_PASSWORD'],
      vhost: ENV['RABBIT_MQ_VHOST']
    }
  end
end
