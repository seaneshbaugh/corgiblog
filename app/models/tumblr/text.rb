module Tumblr
  class Text < PostFactory
    def post_body
      @body = @json['body']
    end

    def post_title
      @title = @json['title']

      super unless @title.present?

      @title
    end
  end
end
