class Picture < ActiveRecord::Base
  has_attached_file :image,
                    path: :attachment_path,
                    styles: -> (_) { attachment_styles },
                    url: :attachment_url

  # Scopes
  scope :chronological, -> { order(:created_at) }

  scope :reverse_chronological, -> { order('pictures.created_at DESC') }

  # Validations
  validates_length_of :title, maximum: 65535
  validates_presence_of :title

  validates_length_of :alt_text, maximum: 65535

  validates_length_of :caption, maximum: 65535

  validates_uniqueness_of :image_fingerprint, if: -> { !Rails.env.test? }

  validates_attachment_presence :image
  validates_attachment_size :image, less_than: 1024.megabytes
  validates_attachment_content_type :image, content_type: %w(image/gif image/jpeg image/jpg image/pjpeg image/png image/svg+xml image/tiff image/x-png)

  # Callbacks
  before_validation :modify_image_file_name

  before_validation :set_default_title

  after_post_process :save_image_dimensions

  # Default Values
  default_value_for :title, ''

  default_value_for :alt_text, ''

  default_value_for :caption, ''

  default_value_for :image_original_width, 1

  default_value_for :image_original_height, 1

  default_value_for :image_medium_width, 1

  default_value_for :image_medium_height, 1

  default_value_for :image_thumb_width, 1

  default_value_for :image_thumb_height, 1

  def self.attachment_styles
    {
      thumb: {
        geometry: '100x100',
        convert_options: '-quality 75 -strip'
      },
      small: {
        geometry: '300x300',
        convert_options: '-quality 80 -strip'
      },
      medium: {
        geometry: '800x800',
        convert_options: '-quality 85 -strip'
      }
    }
  end

  def as_json(options = {})
    json = super(options)

    options[:image_url].each do |image_size|
      json["#{image_size}_image_url"] = image.url(image_size)
    end

    if options[:scaled_width]
      json['scaled_width'] = options[:scaled_width]

      json['scaled_height'] = scale_height(options[:scaled_width])
    elsif options[:scaled_height]
      json['scaled_height'] = options[:scaled_height]

      json['scaled_width'] = scale_width(options[:scaled_height])
    end

    json
  end

  def attachment_path
    ":rails_root/public/uploads/#{Rails.env.test? ? 'test/' : ''}:class/:style_prefix:basename.:extension"
  end

  def attachment_url
    "/uploads/:class/#{Rails.env.test? ? 'test/' : ''}:style_prefix:basename.:extension"
  end

  def scale_height(new_width)
    new_width = new_width.to_f

    ratio = image_original_width.to_f / image_original_height.to_f

    (new_width / ratio).to_i
  end

  def scale_width(new_height)
    new_height = new_height.to_f

    ratio = image_original_height.to_f / image_original_width.to_f

    (new_height / ratio).to_i
  end

  protected

  def modify_image_file_name
    return unless image.file? && image.dirty?

    current_time = Time.now

    basename = "#{current_time.to_i}#{current_time.usec}".ljust(16, '0')

    extension = File.extname(image_file_name).downcase

    extension = '.jpg' if extension == '.jpeg'

    extension = '.tiff' if extension == '.tif'

    image.instance_write :file_name, "#{basename}#{extension}"
  end

  def save_image_dimensions
    original_geometry = Paperclip::Geometry.from_file(image.queued_for_write[:original])
    self.image_original_width = original_geometry.width
    self.image_original_height = original_geometry.height

    medium_geometry = Paperclip::Geometry.from_file(image.queued_for_write[:medium])
    self.image_medium_width = medium_geometry.width
    self.image_medium_height = medium_geometry.height

    thumb_geometry = Paperclip::Geometry.from_file(image.queued_for_write[:thumb])
    self.image_thumb_width = thumb_geometry.width
    self.image_thumb_height = thumb_geometry.height
  end

  def set_default_title
    self.title = File.basename(image_file_name, '.*').to_s if title.blank? && !image_file_name.blank?
  end
end
