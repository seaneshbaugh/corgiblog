module Tumblr
  class Link < PostFactory
    def post_body
      @body = @json['description']
    end

    def post_title
      @title = @json['title']

      super unless @title.present?

      @title
    end
  end
end
