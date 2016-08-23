module OptionsForSelect
  extend ActiveSupport::Concern

  class_methods do
    def options_for_select(*args)
      options = args.extract_options!

      display_method = options.delete(:display_method)

      if display_method.blank?
        display_method = (['name', 'title', 'label', primary_key] & column_names).first.to_sym
      end

      prompt = options.delete(:prompt)

      include_blank = options.delete(:include_blank)

      results = []

      if prompt
        results << [prompt, '']
      elsif include_blank
        results << ['', '']
      end

      if display_method.respond_to?(:call)
        display_method_wrapper = display_method
      else
        display_method_wrapper = -> (object) { object.public_send(display_method) }
      end

      results + all.map { |object| [display_method_wrapper.call(object), object.id] }
    end
  end
end
