Rails.application.config.rabbitmq_connection_settings = {
  host: ENV['RABBIT_MQ_HOST'],
  port: ENV['RABBIT_MQ_PORT'].to_i,
  username: ENV['RABBIT_MQ_USERNAME'],
  password: ENV['RABBIT_MQ_PASSWORD'],
  vhost: ENV['RABBIT_MQ_VHOST']
}
