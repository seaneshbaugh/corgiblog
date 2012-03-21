require "nokogiri"
require "truncate_html"

class Post < ActiveRecord::Base
  belongs_to :user, :validate => true
  has_paper_trail
  paginates_per 10

  before_validation :generate_slug

  validates :title,
    :presence => true,
    :uniqueness => true

  validates :slug,
    :presence => true,
    :uniqueness => true

  validates :status,
    :presence => true,
    :numericality => true

  validate :user_must_exist

  scope :published, lambda { where(:status => 1) }

  def initialize_defaults
    self.status ||= 0
    self.private ||= false
  end

  def user_must_exist
    errors.add(:user_id, t("activerecord.errors.models.post.user_must_exist")) if user_id && user.nil?
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

  def more
    if self.body.include?("<!--more-->")
      self.body[0..self.body.index("<!--more-->") - 1]
    else
      self.body
    end
  end

  def truncated?
    if self.body.include?("<!--more-->")
      return true
    else
      doc = Nokogiri::HTML(self.body)

      current = doc.children.first
      count = 0

      while true
        if current.is_a?(Nokogiri::XML::Text)
          count += current.text.split.length
          break if count > 200
          previous = current
        end

        if current.children.length > 0
          current = current.children.first
        elsif !current.next.nil?
          current = current.next
        else
          n = current
          while !n.is_a?(Nokogiri::HTML::Document) and n.parent.next.nil?
            n = n.parent
          end

          if n.is_a?(Nokogiri::HTML::Document)
            break;
          else
            current = n.parent.next
          end
        end
      end

      return count > 200
    end
    #self.body.length > truncate_html(self.more, 200).length
  end

  def first_image
    body_doc = Nokogiri::HTML(self.body)

    images = body_doc.xpath("//img")

    if images.length > 0
      images[0]["src"]
    else
      nil
    end
  end

  def self.search(search)
    if search
      where("title LIKE :search OR body LIKE :search OR style LIKE :search", { :search => "%#{search}%" })
    else
      scoped
    end
  end
end
