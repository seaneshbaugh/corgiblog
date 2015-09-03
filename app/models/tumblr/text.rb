module Tumblr
  class Text < PostFactory
    def post_body
      @body = @json['body']
    end

    def post_title
      @title = @json['title']

      @title = @json['body'] unless @title.present?

      super
    end
  end
end
