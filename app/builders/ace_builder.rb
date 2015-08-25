class AceBuilder < BootstrapForm::FormBuilder
  include ApplicationHelper

  delegate :content_tag, to: :@template
  delegate :label_tag, to: :@template
  delegate :link_to, to: :@template

  def ace_editor(method, options = {})
    mode = options.delete(:mode) || 'text'

    form_group_builder(method, options) do
      text_area = text_area_without_bootstrap(method, options)

      ace_editor = content_tag(:div, '', id: ace_editor_id_for(method), class: 'ace-editor', data: { 'mode' => mode })

      text_area + ace_editor
    end
  end

  def picture_inserter(method, options = {}, &block)
    link_body = block_given? ? capture(&block) : 'Insert Picture'

    link_class = options.delete(:class) || 'btn btn-default'

    modal_id = "#{object_name}_#{method}-picture-selector-modal"

    form_group_builder(method, options.merge(skip_label: true)) do
      link = link_to(link_body, '/admin/pictures/selector', class: link_class, data: { toggle: 'modal', target: "\##{modal_id}" })

      modal = content_tag(:div, '', id: modal_id, class: 'modal fade', role: 'dialog', data: { target: ace_editor_id_for(method) })

      link + modal
    end
  end

  def ace_editor_id_for(method)
    "#{object_name}_#{method}-editor"
  end
end
