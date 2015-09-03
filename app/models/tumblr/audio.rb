module Tumblr
  class Audio < PostFactory
    def post_body
      capture do
        concat(@json['player'].html_safe)

        concat(@json['caption'].html_safe)
      end
    end

    def post_title
      @title = @json['source_title']

      super
    end
  end
end
