# frozen_string_literal: true

class AceBuilder < ActionView::Helpers::FormBuilder
  include ApplicationHelper

  delegate :content_tag, to: :@template
  delegate :label_tag, to: :@template
  delegate :link_to, to: :@template

  def ace_editor(method, options = {})
    mode = options.delete(:mode) || 'text'

    theme = options.delete(:theme) || 'github'

    content_tag(:div, class: 'ace-editor-field input-field') do
      label = label(method)

      ace_editor = content_tag(:div, '', id: ace_editor_id_for(method), class: 'ace-editor', data: { 'mode' => mode, 'theme' => theme })

      text_area = text_area(method, options.merge(class: 'value'))

      label + ace_editor + text_area
    end
  end

  def picture_inserter(method, options = {}, &block)
    button_class = options.delete(:class) || 'btn btn-flat waves-effect waves-light blue lighten-3'

    button_text = if block_given?
                    capture(&block)
                  else
                    I18n.t('admin.pages.new.insert_picture')
                  end

    target = options.delete(:target) || ace_editor_id_for(method)

    content_tag(:div, '', class: 'picture-selector', data: { 'buttonclassname' => button_class, 'buttontext' => button_text, 'target' => target })
  end

  private

  def ace_editor_id_for(method)
    "#{object_name}_#{method}-editor"
  end
end
