class Page < ActiveRecord::Base
  belongs_to :parent, :class_name => "Page"
  has_many :subpages, :class_name => "Page", :foreign_key => "parent_id", :dependent => :destroy, :order => "display_order"
  has_paper_trail

  after_initialize :initialize_defaults
  before_validation :generate_slug

  validates :title,
    :presence => true,
    :uniqueness => true

  validates :slug,
    :presence => true,
    :uniqueness => true

  validates :display_order,
    :presence => true,
    :numericality => true

  validates :status,
    :presence => true,
    :numericality => true

  validate :parent_must_exist

  scope :top_level, lambda { where(:parent_id => nil) }

  def initialize_defaults
    self.display_order ||= 0
    self.status ||= 0
    self.private ||= false
  end

  def parent_must_exist
    errors.add(:parent_id, I18n.t("activerecord.errors.models.page.parent_must_exist")) if parent_id && parent.nil?
  end

  def to_param
    self.slug
  end

  def generate_slug
    if self.title.blank?
      self.slug = self.id
    else
      self.slug = self.title.parameterize
    end
  end

  def get_dropdown_title
    dropdown_title = ""

    current = self

    while !current.nil? and !current.parent.nil?
      dropdown_title += "-"

      current = current.parent
    end

    if dropdown_title == ""
      dropdown_title = self.title
    else
      dropdown_title += " " + self.title
    end

    dropdown_title
  end

  def self.search(search)
    if search
      where("title LIKE :search OR body LIKE :search OR style LIKE :search", { :search => "%#{search}%" })
    else
      scoped
    end
  end
end
