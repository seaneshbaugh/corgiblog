module Tumblr
  class Audio < PostFactory
    def post_body
      @body = capture do
        concat(@json['player'].html_safe)

        concat(@json['caption'].html_safe)
      end

      super
    end

    def post_title
      if @json['artist'] && @json['track_name']
        @title = "#{@json['artist']} - #{@json['track_name']}"
      elsif @json['track_name']
        @title = @json['track_name']
      end

      super
    end
  end
end
