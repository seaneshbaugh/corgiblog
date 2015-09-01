module Tumblr
  class Photo < PostFactory
    private

    def post_body
      @body = @json['photos'].map do |photo|
        next if photo['original_size'].nil?

        url = photo['original_size']['url']

        next if url.nil? || @photo_map[url].nil?

        picture = @photo_map[url]

        content_tag :p, class: 'center' do
          content_tag :a, href: picture.image.url(:original, timestamp: false) do
            tag :img, { alt: picture.alt_text, src: picture.image.url(:medium, timestamp: false), title: picture.title }, true
          end
        end
      end.compact.join("\n")

      @body += "\n" + @json['caption']
    end

    def post_title
      @title = sanitized_caption
    end
  end
end
