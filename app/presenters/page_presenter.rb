class PagePresenter < BasePresenter
  include FrontEnd
  include Linkable

  delegate :content_tag, to: :@template
  delegate :contrast_color, to: :@template

  def initialize(page, template)
    super

    @page = page
  end

  def color_text
    if @page.color.present?
      "<span style=\"background: #{@page.color}; color: #{contrast_color(@page.color)}; padding: 3px;\">#{@page.color}</span>".html_safe
    else
      ''
    end
  end

  def header_style
    "color: #{@page.color}" if @page.color.present?
  end

  def show_in_menu
    if @page.show_in_menu
      'Yes'
    else
      'No'
    end
  end

  def visible
    if @page.visible
      'Yes'
    else
      'No'
    end
  end

  private

  def base_path
    '/'
  end
end
