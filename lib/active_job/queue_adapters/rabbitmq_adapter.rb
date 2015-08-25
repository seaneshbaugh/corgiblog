module ActiveJob
  module QueueAdapters
    class RabbitmqAdapter
      class << self
        def enqueue(job)
          connection = Bunny.new(Rails.configuration.rabbitmq_connection_settings)

          connection.start

          channel = connection.create_channel

          exchange = channel.fanout("#{job.queue_name}.exchange")

          channel.queue(job.queue_name, auto_delete: true, durable: true).bind(exchange)

          exchange.publish(job.serialize.tap { |serialized_job| serialized_job['tries'] = 0 }.to_json)
        end

        def enqueue_at(_job)
          fail NotImplementedError
        end
      end
    end
  end
end
