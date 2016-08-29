class PagePresenter < BasePresenter
  include FrontEnd
  include Linkable

  def self.display_method
    :title
  end

  def self.version_display_attributes
    [
      {
        method: :title,
        header_class: 'col-xs-5'
      },
      {
        method: :order,
        header_class: 'col-xs-1'
      },
      {
        method: :visible,
        header_class: 'col-xs-1'
      }
    ]
  end

  def initialize(page, template)
    super

    @page = page
  end

  def show_in_menu
    if @page.show_in_menu
      t('yes')
    else
      t('no')
    end
  end

  def visible
    if @page.visible
      t('yes')
    else
      t('no')
    end
  end

  private

  def base_path
    '/'
  end
end
