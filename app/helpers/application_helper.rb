# frozen_string_literal: true

module ApplicationHelper
  include ClassNames

  def error_messages_for(object)
    object.errors.full_messages.uniq.join('. ') + '.'
  end

  def nav_link_to(*args, &block)
    body = block_given? ? capture(&block) : args.shift

    path = args[0]

    html_options = args[1] || {}

    options = args[2] || {}

    NavLinkGenerator.new(request, body, path, html_options, options).to_html
  end

  def page_title(title)
    return t('.title') unless title.present?

    title.strip
  end

  def page_meta_description(meta_description)
    return t('.meta_description') unless meta_description.present?

    meta_description.strip
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize

    presenter = klass.new(object, self)

    yield presenter if block_given?

    presenter
  end

  class NavLinkGenerator
    include ActionView::Helpers::UrlHelper

    def initialize(request, body, path, html_options, options)
      @request = request

      @body = body

      @path = path

      @html_options = html_options

      @options = options
    end

    def to_html
      html = link

      if @options[:wrapper]
        html = content_tag(@options[:wrapper], html, class: wrapper_classes)
      end

      html.html_safe
    end

    private

    def link
      link_to(@body, @path, html_options)
    end

    def html_options
      active? ? @html_options.merge(class: link_classes) : @html_options
    end

    def active?
      segments = @options[:segments] || 1

      @request.path.split('/').reject(&:blank?).first(segments) == @path.split('/').reject(&:blank?).first(segments)
    end

    def link_classes
      if @html_options[:class]
        @html_options[:class].split(' ').push(active_class).join(' ')
      elsif !@options[:wrapper]
        active_class
      end
    end

    def active_class
      @options[:active_class] || 'active'
    end

    def wrapper_classes
      if active?
        if @options[:wrapper_class].blank?
          active_class
        else
          @options[:wrapper_class].split(' ').push(active_class).join(' ')
        end
      else
        @options[:wrapper_class]
      end
    end
  end

  def flash_messages
    render partial: 'shared/flash_messages'
  end
end
