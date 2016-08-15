class PagePresenter < BasePresenter
  include FrontEnd
  include Linkable

  delegate :content_tag, to: :@template

  def self.display_method
    :title
  end

  def self.humanized_attribute_names
    @humanized_attribute_names ||= HashWithIndifferentAccess.new({
      id: 'ID',
      title: 'Title',
      slug: 'Slug',
      body: 'Body',
      style: 'Style',
      meta_description: 'Meta Description',
      meta_keywords: 'Meta Keywords',
      order: 'Order',
      show_in_menu: 'Show in Menu?',
      visible: 'Visible?',
      created_at: 'Created At',
      updated_at: 'Updated At'
    })
  end

  def self.version_display_attributes
    [
      {
        method: :title,
        header_class: 'col-xs-5',
      },
      {
        method: :order,
        header_class: 'col-xs-1',
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
