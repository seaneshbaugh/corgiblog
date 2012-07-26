class Picture < ActiveRecord::Base
  attr_accessible :title, :alt_text, :caption

  has_attached_file :image, :path => ":rails_root/uploads/#{'test/' if Rails.env.test?}:class:id/:basename.:extension"

  validates_presence_of :title

  validates_uniqueness_of :image_fingerprint

  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 1024.megabytes
  validates_attachment_content_type :image, :content_type => ['image/gif', 'image/jpeg', 'image/jpg', 'image/pjpeg', 'image/png', 'image/svg+xml', 'image/tiff', 'image/x-png']

  before_validation :modify_image_file_name
  before_validation :set_default_title

  before_post_process :no_image_processing?

  default_scope :order => 'created_at DESC'

  protected

  def modify_image_file_name
    if image.file?
      if image.dirty?
        current_time = Time.now

        basename = (current_time.to_i.to_s + current_time.usec.to_s).ljust(16, '0')

        extension = File.extname(self.image_file_name).downcase

        if extension == '.jpeg'
          extension = '.jpg'
        end

        if extension == '.tif'
          extension = '.tiff'
        end

        self.asset_content_type = 'application/pdf' if extension.match /pdf/
        self.image.instance_write :file_name, "#{basename}#{extension}"
      end
    end
  end

  def set_default_title
    self.name = File.basename(self.image_file_name, ".*").to_s if self.title.blank? && !self.image_file_name.blank?
  end

  def no_image_processing?
    extension = File.extname(self.image_file_name).downcase

    extension.match /pdf/
  end
end
