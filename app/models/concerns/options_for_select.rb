# frozen_string_literal: true

# TODO: Consider moving this to a presenter.
module OptionsForSelect
  extend ActiveSupport::Concern

  module ClassMethods
    def default_display_method
      if column_names.include?('name')
        :name
      elsif column_names.include?('title')
        :title
      elsif column_names.include?('label')
        :label
      else
        primary_key.to_sym
      end
    end

    def options_for_select(*args)
      options = args.extract_options!

      display_method = options.delete(:display_method)

      display_method = default_display_method if display_method.blank?

      prompt = options.delete(:prompt)

      include_blank = options.delete(:include_blank)

      results = []

      if prompt
        results << [prompt, '']
      elsif include_blank
        results << ['', '']
      end

      display_method_wrapper = if display_method.respond_to?(:call)
                                 display_method
                               else
                                 ->(object) { object.public_send(display_method) }
                               end

      results + all.map { |object| [display_method_wrapper.call(object), object.id] }
    end
  end
end
