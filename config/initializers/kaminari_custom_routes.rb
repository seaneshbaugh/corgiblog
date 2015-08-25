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
        default_options = {
          current_page: scope.current_page,
          num_pages: scope.num_pages,
          per_page: scope.limit_value,
          param_name: Kaminari.config.param_name,
          remote: false,
          route: :url_for
        }

        paginator = Kaminari::Helpers::Paginator.new self, options.reverse_merge(default_options)

        paginator.to_s
      end
    end
  end

  module Helpers
    PARAM_KEY_BLACKLIST = :authenticity_token, :commit, :utf8, :_method

    class Tag
      def initialize(template, options = {})
        @template, @options = template, options.dup

        @param_name = @options.delete(:param_name) || Kaminari.config.param_name

        @route = @options.delete(:route)

        @theme = @options.delete(:theme)

        @views_prefix = @options.delete(:views_prefix)

        @params = template.params.except(*PARAM_KEY_BLACKLIST).merge(@options.delete(:params) || {})

        if @params.instance_variable_defined?(:@parameters) && !@params.respond_to?(:deep_merge)
          @params = @params.instance_variable_get :@parameters
        else
          @params = @params.with_indifferent_access
        end
      end

      def page_url_for(page)
        if @route && @route.respond_to?(:to_sym)
          @template.send @route.to_sym, @params.reject { |k, _| ['controller', 'action'].include?(k) }.merge(@param_name => (page <= 1 ? nil : page))
        else
          @template.url_for @params.merge(@param_name => (page <= 1 ? nil : page), only_path: true)
        end
      end
    end
  end
end
