module RabbitmqJobProcessor
  class Worker
    @logger = nil

    def self.logger
      @logger
    end

    def self.logger=(new_logger)
      @logger = new_logger
    end

    def self.reload_app?
      defined?(ActionDispatch::Reloader) && Rails.application.config.cache_classes == false
    end

    def initialize(options = {})
      @queue_names = options[:queues]
    end

    def logger
      self.class.logger
    end

    def say(text, level = 'info')
      puts text

      return unless logger

      self.class.logger.send(level, text)
    end

    def start
      trap('TERM') do
        Thread.new { say 'Exiting...' }

        stop
      end

      trap('INT') do
        Thread.new { say 'Exiting...' }

        stop
      end

      say 'Worker started.'

      begin
        @connection = Bunny.new(Rails.configuration.rabbitmq_connection_settings)

        @connection.start

        @channel = @connection.create_channel

        @exchanges = []

        @retry_exchanges = []

        @queues = []

        @retry_queues = []

        @queue_names.each do |queue_name|
          exchange = @channel.fanout("#{queue_name}.exchange")

          retry_exchange = @channel.fanout("#{queue_name}.retry.exchange")

          retry_queue = @channel.queue("#{queue_name}_retry", auto_delete: true, durable: true, arguments: { 'x-dead-letter-exchange' => exchange.name, 'x-message-ttl' => 10000 }).bind(retry_exchange)

          queue = @channel.queue(queue_name, auto_delete: true, durable: true).bind(exchange)

          queue.subscribe do |_delivery_info, _metadata, payload|
            begin
              parsed_payload = JSON.parse(payload)

              say "Recieved job #{parsed_payload['job_id']} for \"#{parsed_payload['queue_name']}\". Job Class: #{parsed_payload['job_class']}. Arguments: #{parsed_payload['arguments']}"

              job = parsed_payload['job_class'].constantize.new

              job.perform(parsed_payload['arguments'].first)

              say "Finished processing job #{parsed_payload['job_id']} for \"#{parsed_payload['queue_name']}\"."
            rescue => exception
              say "#{exception.message}\n#{exception.backtrace.join("\n")}", 'error'

              if parsed_payload['tries'] < 5
                parsed_payload['tries'] += 1

                say "Retrying job, #{5 - parsed_payload['tries']} tries remaining."

                retry_exchange.publish(parsed_payload.to_json)
              else
                say 'Maximum number of retries reached. Deleting job.'
              end
            end
          end

          @queues << queue

          @retry_queues << retry_queue

          @exchanges << exchange

          @retry_exchanges << retry_exchange
        end
      rescue => exception
        say "#{exception.message}\n#{exception.backtrace.join("\n")}", 'error'

        raise exception
      end

      loop do
        break if stop?

        sleep 5
      end
    end

    def stop
      @connection.close if @connection

      @exit = true
    end

    def stop?
      !!@exit
    end

    private

    def reload!
      return unless self.class.reload_app?

      ActionDispatch::Reloader.cleanup!

      ActionDispatch::Reloader.prepare!
    end
  end
end
