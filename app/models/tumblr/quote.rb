module Tumblr
  class Quote < PostFactory
    def post_body
      @body = content_tag('blockquote', class: 'tumblr-quote') do
        concat(content_tag :p, @json['text'].html_safe, class: 'tumblr-quote-text')

        concat(content_tag('cite', class: 'tumblr-quote-source') do
          concat(' &mdash; '.html_safe)

          concat(@json['source'].html_safe)
        end)
      end
    end

    def post_title
      @title = truncate(@json['text'].html_safe, escape: false, length: 40, omission: '', separator: ' ')

      super unless @title.present?

      @title
    end
  end
end
