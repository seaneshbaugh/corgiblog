module Tumblr
  class PostFactory
    include ActionView::Context
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::UrlHelper

    VALID_POST_TYPES = %w(answer audio chat link photo quote text video)

    class << self
      alias :__new__ :new

      def inherited(subclass)
        class << subclass
          alias :new :__new__
        end
      end
    end

    def self.new(json)
      post_type = json['type']

      fail ArgumentError, "Unknown post type #{post_type.inspect}." unless VALID_POST_TYPES.include?(post_type)

      post_class = Kernel.const_get("Tumblr::#{post_type.capitalize}")

      post_class.new(json)
    end

    def self.tumblr_user
      @tumblr_user ||= ::User.where(email: 'casie@conneythecorgi.com').first
    end

    def initialize(json)
      @json = json

      @tumblr_id = @json['id'].to_s

      begin
        @date = DateTime.parse(@json['date'])
      rescue ArgumentError, TypeError
        @date = DateTime.now
      end

      @tags = @json['tags']

      @photos = []

      @photo_map = {}
    end

    def download_photos!
      return if @json['photos'].nil?

      @photo_map = {}

      @photos = @json['photos'].map do |photo|
        next if photo['original_size'].nil?

        url = photo['original_size']['url']

        next if url.nil?

        response = HTTParty.get(url)

        fail "Error downloading \"#{url}\": #{response.code} - #{response.message}" unless response.code == 200

        data = response.body

        fingerprint = Digest::MD5.hexdigest(data)

        existing_picture = Picture.where(image_fingerprint: fingerprint).first

        unless existing_picture.nil?
          @photo_map[url] = existing_picture

          next existing_picture
        end

        original_filename = URI.parse(url).path.split('/').last

        temp_file = Tempfile.new([File.basename(original_filename, '.*'), File.extname(original_filename).downcase])

        temp_file.binmode

        temp_file.write(data)

        caption = photo['caption']

        caption = @json['caption'] || '' if caption.blank?

        title = Sanitize.clean(caption, caption_sanitization_options).strip

        new_picture = Picture.create(title: title, alt_text: title, caption: caption, image: temp_file)

        @photo_map[url] = new_picture

        new_picture
      end.compact
    end

    def to_post
      post = ::Post.where(tumblr_id: @tumblr_id).first || ::Post.new

      post.title = post_title

      post.body = post_body

      post.user = Tumblr::PostFactory.tumblr_user

      post.tumblr_id = @tumblr_id

      post.tag_list = @tags

      post
    end

    private

    def post_body
      @body = ''
    end

    def post_title
      @title = "Tumblr post from #{@date.strftime('%-m/%-d/%Y')} at #{@date.strftime('%l:%M:%S %p').strip}"
    end

    def caption_sanitization_options
      {
        whitespace_elements: {
          'br' => {
            before: '',
            after: ' '
          },
          'p' => {
            before: '',
            after: ' '
          }
        }
      }
    end
  end
end
