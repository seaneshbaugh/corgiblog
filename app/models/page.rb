class Page < ActiveRecord::Base
  include OptionsForSelect
  include Slugable

  # Scopes
  scope :alphabetical, -> { order(:title) }

  scope :by_order, -> { order(:order) }

  scope :in_menu, -> { where(show_in_menu: true) }

  scope :published, -> { where(visible: true) }

  scope :reverse_alphabetical, -> { order('pages.title DESC') }

  validates_length_of :title, maximum: 255
  validates_presence_of :title
  validates_uniqueness_of :title

  validates_length_of :body, maximum: 16_777_215

  validates_length_of :style, maximum: 4_194_303

  validates_length_of :meta_description, maximum: 65535

  validates_length_of :meta_keywords, maximum: 65535

  validates_inclusion_of :order, in: -2_147_483_648..2_147_483_647, message: 'is out of range'
  validates_numericality_of :order, only_integer: true

  validates_inclusion_of :show_in_menu, in: [true, false], message: 'must be true or false'

  validates_inclusion_of :visible, in: [true, false], message: 'must be true or false'

  # Default Values
  default_value_for :title, ''

  default_value_for :slug, ''

  default_value_for :body, ''

  default_value_for :style, ''

  default_value_for :meta_description, ''

  default_value_for :meta_keywords, ''

  default_value_for :order, 0

  default_value_for :show_in_menu, true

  default_value_for :visible, true

  has_paper_trail

  def first_image
    body_doc = Nokogiri::HTML(body)

    images = body_doc.xpath('//img')

    if images.length > 0
      images[0]['src']
    else
      nil
    end
  end

  def published?
    visible
  end
end
