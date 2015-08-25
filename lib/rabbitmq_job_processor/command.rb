unless ENV['RAILS_ENV'] == 'test'
  begin
    require 'daemons'
  rescue LoadError
    raise 'The "daemons" gem is required to run this command.'
  end
end

require 'optparse'

require_relative './worker'

module RabbitmqJobProcessor
  class Command
    def initialize(args)
      @options = {
        log_dir: File.join(root_dir, 'log'),
        monitor: false,
        pid_dir: File.join(root_dir, 'tmp', 'pids'),
        queues: [],
        worker_count: 1
      }

      options = OptionParser.new do |opt|
        opt.banner = "Usage: #{File.basename($PROGRAM_NAME)} [options] start|stop|restart"

        opt.on('-h', '--help', 'Show this message and exit.') do
          puts opt

          exit 1
        end

        opt.on('--log-dir=DIR', 'Specifies an alternate directory in which to store the log.') do |dir|
          @options[:log_dir] = dir
        end

        opt.on('-m', '--monitor', 'Start monitor process.') do
          @options[:monitor] = true
        end

        opt.on('-n', '--number_of_workers=workers', 'Number of unique workers to spawn.') do |worker_count|
          @options[:worker_count] = worker_count.to_i rescue 1
        end

        opt.on('--pid-dir=DIR', 'Specifies an alternate directory in which to store the process id.') do |dir|
          @options[:pid_dir] = dir
        end

        opt.on('-q', '--queues=QUEUES', 'Comma delimited list of queues to watch. (required)') do |queues|
          @options[:queues] = queues.split(',')
        end
      end

      @args = options.parse!(args)

      if @options[:queues].empty?
        puts 'You must specify at least one queue to watch.'

        exit 1
      end

      @args = args
    end

    def daemonize
      FileUtils.mkdir_p(@options[:pid_dir]) unless File.exist?(@options[:pid_dir])

      FileUtils.mkdir_p(@options[:log_dir]) unless File.exist?(@options[:log_dir])

      @options[:worker_count].times do |worker_index|
        process_name = @options[:worker_count] == 1 ? 'rabbitmq_job_processor_worker' : "rabbitmq_job_processor_worker_#{worker_index}"

        run_process(process_name)
      end
    end

    def run_process(process_name)
      Daemons.run_proc(process_name, dir: @options[:pid_dir], dir_mode: :normal, monitor: @options[:monitor], ARGV: @args) do |*_args|
        run process_name
      end
    end

    def run(worker_name)
      Dir.chdir(root_dir)

      logger = Logger.new(File.join(@options[:log_dir], 'rabbitmq_job_processor.log'))

      RabbitmqJobProcessor::Worker.logger = logger

      worker = RabbitmqJobProcessor::Worker.new(@options)

      worker.start
    rescue => exception
      STDERR.puts exception.message

      STDERR.puts exception.backtrace

      exit 1
    end

    private

    def rails_root_defined?
      defined?(::Rails.root)
    end

    def root_dir
      @root_dir ||= rails_root_defined? ? ::Rails.root : Dir.pwd
    end
  end
end
