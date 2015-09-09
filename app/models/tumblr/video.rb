module Tumblr
  class Video < PostFactory
    def post_body
      @body = capture do
        concat(@json['player'].sort_by { |player| player['width'] }.last['embed_code'].html_safe)

        concat(@json['caption'].html_safe)
      end

      super
    end

    def post_title
      @title = @json['source_title']

      super
    end
  end
end
