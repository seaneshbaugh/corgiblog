class Page < ActiveRecord::Base
  attr_accessible :title, :body, :style, :meta_description, :meta_keywords, :order, :show_in_menu, :visible

  has_paper_trail

  validates_presence_of   :title
  validates_uniqueness_of :title

  validates_presence_of   :slug
  validates_uniqueness_of :slug

  before_validation :generate_slug

  def published?
    visible
  end

  def to_param
    self.slug
  end

  def first_image
    body_doc = Nokogiri::HTML(self.body)

    images = body_doc.xpath('//img')

    if images.length > 0
      images[0]['src']
    else
      nil
    end
  end

  protected

  def generate_slug
    if self.title.blank?
      self.slug = self.id.to_s
    else
      self.slug = self.title.parameterize
    end
  end
end
