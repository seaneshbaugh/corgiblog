module Tumblr
  class PostFactory
    include ActionView::Context
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::UrlHelper

    VALID_POST_TYPES = %w(answer audio chat link photo quote text video).freeze

    class << self
      alias __new__ new

      def inherited(subclass)
        class << subclass
          alias_method new __new__
        end
      end
    end

    def self.new(json)
      post_type = json['type']

      raise ArgumentError, "Unknown post type #{post_type.inspect}." unless VALID_POST_TYPES.include?(post_type)

      post_class = Kernel.const_get("Tumblr::#{post_type.capitalize}")

      post_class.new(json)
    end

    # The idea here is that some characters (namely right/left quotes) are so
    # awful and so disruptive when copied/pasted that we never want to see them
    # anywhere under any circumstances. This defines a map between regular
    # expressions that match all possible bad characters or their HTML entities
    # and the sane output character that we want to use, even if it gets turned
    # into an HTML entity later.
    def self.invalid_character_map
      {
        /\u2018|\u2019|&#8216;|&#8217;|&#x2018;|&#x2019;|&lsquo;|&rsquo;|&apos;/ => "'",
        /\u201C|\u201D|&#8220;|&#8221;|&#x201c;|&#x201d;|&ldquo;|&rdquo;/ => "\"",
        /\u00A0|&#160;|&#xA0;/ => ' '
      }
    end

    def self.remove_invalid_characters(text)
      invalid_character_map.inject(text) { |result, (regex, replacement)| result.gsub(regex, replacement) }
    end

    def self.sanitize_options
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

        raise "Error downloading \"#{url}\": #{response.code} - #{response.message}" unless response.code == 200

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

        caption = PostFactory.remove_invalid_characters(caption)

        title = Sanitize.clean(caption, PostFactory.sanitize_options)

        title = PostFactory.remove_invalid_characters(title).strip.gsub(/\s/, ' ').squeeze(' ')

        title = truncate(title.html_safe, escape: false, length: 128, omission: '', separator: ' ')

        title = HTMLEntities.new(:html4).encode(title, :named, :hexadecimal).gsub(/&#x27;|&#39;/, "'")

        title = truncate(title, escape: false, length: 255, omission: '', separator: /\s|&.+;/)

        new_picture = Picture.create(title: title, alt_text: title, caption: caption, image: temp_file)

        @photo_map[url] = new_picture

        new_picture
      end.compact
    end

    def to_post
      post = ::Post.where(tumblr_id: @tumblr_id).first || ::Post.new

      post.title = deduplicate(:title, post_title)

      post.body = post_body

      post.user = Tumblr::PostFactory.tumblr_user

      post.tumblr_id = @tumblr_id

      post.created_at = @date

      post.tag_list = @tags

      post
    end

    private

    def deduplicate(attribute_name, attribute_value)
      # Obviously deduping the primary key or the tumblr_id makes no sense. Only allowing
      # attribute_value to be a String is a bit of an artificial restriction but I think
      # for anything but strings what it means exactly to dedup the value in the database
      # is not necessarily clear. Appending a number to a string to ensure it does not
      # collide with existing strings is a pretty common idiom (e.g. copying and pasting
      # a file to a directory that already has a similarly named file in Windows or OS X).
      return attribute_value if attribute_name == :id || attribute_name == :tumblr_id || !attribute_value.is_a?(String)

      n = 1

      loop do
        # This is only necessary for now while ActiveRecord does not support or queries
        # directly. Starting in Rails 5 (late 2015) we'll be able to do something like:
        # ::Post.where(attribute_name => attribute_value).and.not.where(tumblr_id: @tumblr_id).or.where(tumblr_id: nil)
        # In the mean time we have to manually chain together AREL objects. The code is
        # messy but still better than directly writing the SQL in my opinion.
        duplicate = ::Post.where(::Post.arel_table[attribute_name].eq(attribute_value).and(::Post.arel_table[:tumblr_id].eq(@tumblr_id).not.or(::Post.arel_table[:tumblr_id].eq(nil)))).first

        break if duplicate.nil?

        attribute_value = "#{attribute_value} #{n}"

        n += 1
      end

      attribute_value
    end

    def post_body
      @body = '' if @body.nil?

      @body = PostFactory.remove_invalid_characters(@body).gsub(/\s/, ' ').gsub(/&#x27;|&#39;/, "'").squeeze(' ').strip
    end

    def post_title
      @title = "Tumblr post from #{@date.strftime('%-m/%-d/%Y')} at #{@date.strftime('%l:%M:%S %p').strip}" if @title.blank?

      @title = Sanitize.clean(@title, PostFactory.sanitize_options)

      @title = PostFactory.remove_invalid_characters(@title).gsub(/\s/, ' ').squeeze(' ').strip

      @title = truncate(@title.html_safe, escape: false, length: 64, omission: '', separator: ' ')

      @title = HTMLEntities.new(:html4).encode(@title, :named, :hexadecimal).gsub(/&#x27;|&#39;/, "'")

      @title = truncate(@title, escape: false, length: 128, omission: '', separator: /\s|&.+;/)
    end
  end
end
