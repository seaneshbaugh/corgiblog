module FrontEnd
  extend ActiveSupport::Concern

  included do
    delegate :content_tag, to: :@template
  end

  def body_tag
    content_tag(:div, @object.body.html_safe, class: 'body-content')
  end

  def style_tag
    content_tag(:style, @object.style.html_safe) if @object.style.present?
  end
end
