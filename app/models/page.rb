class Page < ActiveRecord::Base
  attr_accessible :title, :body, :style, :meta_description, :meta_keywords, :parent_id, :display_order, :status, :private

  belongs_to :parent, :class_name => 'Page'
  has_many :subpages, :class_name => 'Page', :foreign_key => 'parent_id', :dependent => :destroy, :order => 'display_order'

  has_paper_trail

  paginates_per 10

  validates_presence_of   :title
  validates_uniqueness_of :title

  validates_presence_of   :slug
  validates_uniqueness_of :slug

  validates_inclusion_of    :status, :in => [0, 1, 2, 3]
  validates_numericality_of :status
  validates_presence_of     :status

  validate :parent_exists

  before_validation :generate_slug

  after_initialize :initialize_defaults

  default_scope :order => 'created_at DESC'

  scope :published, where(:published => 1)

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

  def dropdown_title
    ddt = ""

    current = self

    while !current.nil? && !current.parent.nil?
      ddt += "-"

      current = current.parent
    end

    if ddt == ""
      self.title
    else
      ddt + " " + self.title
    end
  end

  protected

  def initialize_defaults
    self.display_order ||= 0
    self.status ||= 0
    self.private = true if self.private.nil?
  end

  def generate_slug
    if self.title.blank?
      self.slug = self.id.to_s
    else
      self.slug = self.title.parameterize
    end
  end

  def parent_exists
    #TODO: i18n this
    errors.add(:parent_id, 'Must be a page that exists.') if self.parent_id && self.parent.nil?
  end
end
