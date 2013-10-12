class Page < ActiveRecord::Base
  attr_accessible :title, :body, :style, :meta_description, :meta_keywords, :order, :show_in_menu, :visible

  has_paper_trail

  validates_length_of     :title, :maximum => 255
  validates_presence_of   :title
  validates_uniqueness_of :title

  validates_length_of     :slug, :maximum => 255
  validates_presence_of   :slug
  validates_uniqueness_of :slug

  validates_length_of :body, :maximum => 65535

  validates_length_of :style, :maximum => 65535

  validates_length_of :meta_description, :maximum => 65535

  validates_length_of :meta_keywords, :maximum => 65535

  after_initialize do
    if self.new_record?
      self.title ||= ''
      self.body ||= ''
      self.style ||= ''
      self.meta_description ||= ''
      self.meta_keywords ||= ''
      self.order ||= 0

      if self.show_in_menu.nil?
        self.show_in_menu = true
      end

      if self.visible.nil?
        self.visible = true
      end
    end
  end

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
