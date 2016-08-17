module Linkable
  extend ActiveSupport::Concern

  module ClassMethods
    def path_and_url_links(method_name, options = {}, &block)
      if options[:plural]
        path_method_name = "#{method_name}_path_links".to_sym

        url_method_name = "#{method_name}_url_links".to_sym
      else
        path_method_name = "#{method_name}_path_link".to_sym

        url_method_name = "#{method_name}_url_link".to_sym
      end

      send :define_method, path_method_name do |*args|
        instance_exec(:path, args, &block)
      end

      send :define_method, url_method_name do |*args|
        instance_exec(:url, args, &block)
      end
    end
  end

  def link(options = {})
    link_to @object.title, path, options
  end

  def share_link(options = {})
    link_to '<span class="glyphicon glyphicon-share"</span>'.html_safe, path, options
  end

  def path
    "#{base_path}#{@object.slug}"
  end

  private

  def path_or_url_for(path_or_url, method_name, *args)
    if path_or_url == :url
      @template.send("#{method_name}_url".to_sym, *args)
    elsif path_or_url == :path
      @template.send("#{method_name}_path".to_sym, *args)
    else
      raise ArgumentError, 'expected path_or_url to be either :path or :url'
    end
  end
end
