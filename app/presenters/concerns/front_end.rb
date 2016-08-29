module FrontEnd
  extend ActiveSupport::Concern

  def body_tag
    content_tag(:div, @object.body.html_safe, class: 'body-content')
  end

  def style_tag
    content_tag(:style, @object.style.html_safe) if @object.style.present?
  end
end
