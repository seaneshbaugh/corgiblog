require 'active_support/configurable'

module Kaminari
  class Configuration
    config_accessor :route
  end

  configure do |config|
    config.route = :url_for
  end

  module ActionViewExtension
    module InstanceMethods
      def paginate(scope, options = {}, &block)
        paginator = Kaminari::Helpers::Paginator.new self, options.reverse_merge(:current_page => scope.current_page, :num_pages => scope.num_pages, :per_page => scope.limit_value, :param_name => Kaminari.config.param_name, :remote => false, :route => :url_for)
        paginator.to_s
      end
    end
  end

  module Helpers
    class Tag
      def initialize(template, options = {})
        @template, @options = template, options.dup
        @param_name = @options.delete(:param_name)
        @route = @options.delete(:route)
        @theme = @options[:theme] ? "#{@options.delete(:theme)}/" : ''
        @params = @options[:params] ? template.params.merge(@options.delete :params) : template.params
      end

      def page_url_for(page)
        if @route && @route.respond_to?(:to_sym)
          @template.send(@route.to_sym, @params.merge(@param_name => (page <= 1 ? nil : page)))
        else
          @template.url_for @params.merge(@param_name => (page <= 1 ? nil : page))
        end
      end
    end
  end
end
