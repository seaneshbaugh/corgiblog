class Picture < ActiveRecord::Base
  attr_accessible :title, :alt_text, :caption, :image

  mount_uploader :image, ImageUploader

  before_validation :update_md5
  validate :md5_must_be_unique

  def update_md5
    self.md5 = Digest::MD5.file(self.image.current_path).to_s
  end

  def md5_must_be_unique
    if self.new_record?
      duplicates = Picture.where("md5 = ?", self.md5)
    else
      duplicates = Picture.where("id != ? AND md5 = ?", self.id, self.md5)
    end

    errors.add(:md5, I18n.t("activerecord.errors.models.picture.md5_must_be_unique")) if duplicates.length > 0
  end

  def self.search(search)
    if search
      where("title LIKE :search OR alt_text LIKE :search OR caption LIKE :search", { :search => "%#{search}%" })
    else
      scoped
    end
  end
end
