module Tumblr
  class Video < PostFactory
        def post_body
      capture do
        concat(@json['player'].html_safe)

        concat(@json['caption'].html_safe)
      end
    end

    def post_title
      @title = @json['source_title']

      super unless @title.present?

      @title
    end
  end
end
