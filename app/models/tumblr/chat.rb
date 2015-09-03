module Tumblr
  class Chat < PostFactory
    def post_body
      @body = content_tag(:ul, class: 'conversation') do
        @json['dialogue'].each_with_index do |chat_item, index|
          if (index + 1).even?
            li_class = 'chat-even'
          else
            li_class = 'chat-odd'
          end

          concat(content_tag(:li, class: li_class) do
            concat(content_tag(:span, chat_item['label'], class: 'label'))

            concat("&quot;#{chat_item['phrase']}&quot;".html_safe)
          end)
        end
      end
    end

    def post_title
      @title = @json['title']

      super
    end
  end
end
