class PagePresenter < BasePresenter
  include FrontEnd
  include Linkable

  delegate :content_tag, to: :@template

  def initialize(page, template)
    super

    @page = page
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
