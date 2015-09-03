module Tumblr
  class Link < PostFactory
    def post_body
      @body = @json['description']
    end

    def post_title
      @title = @json['title']

      super
    end
  end
end
