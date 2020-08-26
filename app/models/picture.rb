# frozen_string_literal: true

class Picture < ApplicationRecord
  include FriendlyId
  include Rails.application.routes.url_helpers

  has_one_attached :image

  validates :title, presence: true, length: { maximum: 65535 }
  validates :alt_text, length: { maximum: 65535 }
  validates :caption, length: { maximum: 65535 }
  validates :image, image_attachment: true
  # validates :image_fingerprint, uniqueness: { if: -> { !Rails.env.test? } }
  # validates_attachment_presence :image
  # validates_attachment_size :image, less_than: 1024.megabytes
  # validates_attachment_content_type :image, content_type: %w[image/gif image/jpeg image/jpg image/pjpeg image/png image/svg+xml image/tiff image/x-png]

  before_validation :ensure_title
  # before_validation :normalize_image_file_name
  # after_post_process :save_image_dimensions

  friendly_id :timestamp

  resourcify

  def image_filename
    image.blob.filename.to_s if image.attached?
  end

  # TODO: Consider DRYing this?
  def medium_image_path
    rails_representation_url(image.variant(resize: '500x500'), only_path: true)
  end

  def medium_image_url
    rails_representation_url(image.variant(resize: '500x500'))
  end

  def original_image_path
    rails_blob_path(image, only_path: true)
  end

  def original_image_url
    rails_blob_url(image)
  end

  def thumbnail_image_path
    rails_representation_url(image.variant(resize: '100x100'), only_path: true)
  end

  def thumbnail_image_url
    rails_representation_url(image.variant(resize: '100x100'))
  end

  private

  def default_title
    File.basename(image_filename, '.*').to_s
  end

  def ensure_title
    self.title = default_title if title.blank? && image_filename.present?
  end

  def normalize_image_file_name
    return unless image.file? && image.dirty?

    current_time = Time.now

    basename = "#{current_time.to_i}#{current_time.usec}".ljust(16, '0')

    extension = File.extname(image_file_name).downcase

    extension = '.jpg' if extension == '.jpeg'

    extension = '.tiff' if extension == '.tif'

    image.instance_write(:file_name, "#{basename}#{extension}")
  end

  def timestamp
    current_time = Time.now

    "#{current_time.to_i}#{current_time.usec}".ljust(16, '0')
  end

  # def save_image_dimensions
  #   original_geometry = Paperclip::Geometry.from_file(image.queued_for_write[:original])

  #   self.image_original_width = original_geometry.width
  #   self.image_original_height = original_geometry.height

  #   medium_geometry = Paperclip::Geometry.from_file(image.queued_for_write[:medium])

  #   self.image_medium_width = medium_geometry.width
  #   self.image_medium_height = medium_geometry.height

  #   thumb_geometry = Paperclip::Geometry.from_file(image.queued_for_write[:thumb])

  #   self.image_thumb_width = thumb_geometry.width
  #   self.image_thumb_height = thumb_geometry.height
  # end
end
