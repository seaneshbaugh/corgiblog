require 'rails'
require 'rails/generators'
require 'rails/generators/generated_attribute'

class LocalesGenerator < ::Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :controller_path, :type => :string
  argument :model_name, :type => :string, :required => false

  def initialize(args, *options)
    super(args, *options)
    initialize_locale_variables
  end

  def copy_locales
    generate_locales
  end

  protected

  def initialize_locale_variables
    @base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(controller_path)
    @controller_routing_path = @controller_file_path.gsub(/\//, '_')
    @model_name = @controller_class_nesting + "::#{@base_name.singularize.camelize}" unless @model_name
    @model_name = @model_name.camelize
  end

  def controller_routing_path
    @controller_routing_path
  end

  def singular_controller_routing_path
    @controller_routing_path.singularize
  end

  def model_name
    @model_name
  end

  def plural_model_name
    @model_name.pluralize
  end

  def resource_name
    @model_name.demodulize.underscore
  end

  def plural_resource_name
    resource_name.pluralize
  end

  def columns
    begin
      excluded_column_names = %w[id]
      @model_name.constantize.columns.reject{ |c| excluded_column_names.include?(c.name) }.collect{ |c| ::Rails::Generators::GeneratedAttribute.new(c.name, c.type) }
    rescue NoMethodError
      @model_name.constantize.fields.collect { |c| c[1] }.reject{ |c| excluded_column_names.include?(c.name) }.collect{ |c| ::Rails::Generators::GeneratedAttribute.new(c.name, c.type.to_s) }
    end
  end

  def extract_modules(name)
    modules = name.include?('/') ? name.split('/') : name.split('::')
    name = modules.pop
    path = modules.map { |m| m.underscore }
    file_path = (path + [name.underscore]).join('/')
    nesting = modules.map { |m| m.camelize }.join('::')
    [name, path, file_path, nesting, modules.size]
  end

  def generate_locales
    locales = {
      'model.yml' => File.join('config/locales/models', @controller_file_path, 'en.yml'),
      'view.yml' => File.join('config/locales/views', @controller_file_path, 'en.yml')
    }

    selected_locales = locales
    options.engine == generate_erb(selected_locales)
  end

  def generate_erb(views)
    views.each do |template_name, output_path|
      template template_name, output_path
    end
  end

  def ext
    ::Rails.application.config.generatgors.options[:rails][:template_engine] || :erb
  end
end
