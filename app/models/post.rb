# frozen_string_literal: true

class Post < ApplicationRecord
  include FriendlyId
  include OptionsForSelect

  scope :alphabetical, -> { order(:title) }
  scope :published, -> { where(visible: true) }
  scope :reverse_alphabetical, -> { order(title: :desc) }
  scope :unpublished, -> { where(visible: false) }
  scope :sticky_first, -> { order(sticky: :desc) }

  belongs_to :user

  validates :user_id, presence: true
  validates_associated :user
  validates :title, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :body, presence: true, length: { minimum: 4, maximum: 16_777_215 }
  validates :style, length: { maximum: 4_194_303 }
  validates :script, length: { maximum: 4_194_303 }
  validates :meta_description, length: { maximum: 65535 }
  validates :meta_keywords, length: { maximum: 65535 }
  validates :visible, inclusion: { in: [true, false] }

  before_validation :nilify_blank_tumblr_id

  acts_as_taggable

  friendly_id :title

  has_paper_trail

  resourcify

  def published?
    visible
  end

  private
  def nilify_blank_tumblr_id
    self.tumblr_id = nil if tumblr_id.blank?
  end
end
