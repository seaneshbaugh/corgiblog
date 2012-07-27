require 'nokogiri'

class Post < ActiveRecord::Base
  attr_accessible :title, :body, :style, :meta_description, :meta_keywords, :user_id, :status, :private

  belongs_to :user, :validate => true

  has_paper_trail

  paginates_per 10

  validates_presence_of   :title
  validates_uniqueness_of :title

  validates_presence_of   :slug
  validates_uniqueness_of :slug

  validates_inclusion_of    :status, :in => [0, 1, 2, 3]
  validates_numericality_of :status
  validates_presence_of     :status

  validate :user_exists

  before_validation :generate_slug

  after_initialize :initialize_defaults

  default_scope :order => 'created_at DESC'

  scope :published, where(:status => 1)

  def to_param
    self.slug
  end

  def more
    if self.body.include?('<!--more-->')
      self.body[0..self.body.index('<!--more-->') - 1]
    else
      self.body
    end
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

  def initialize_defaults
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

  def user_exists
    #TODO: i18n this
    errors.add(:user_id, 'Must be a user that exists.') if self.user_id && self.user.nil?
  end
end
