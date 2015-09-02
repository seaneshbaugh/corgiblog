module Tumblr
  class Answer < PostFactory
    def post_body
      capture do
        concat(content_tag(:div, class: 'question') do
          concat(content_tag(:p, class: 'asker') do
            concat(content_tag(:strong, @json['asking_name']))

            concat(' asked:')
          end)

          concat(content_tag(:p, @json['question'], class: 'question-text'))
        end)

        concat(content_tag(:div, class: 'answer') do
          concat(@json['answer'].html_safe)
        end)
      end
    end

    def post_title
      if @json['asking_name'].present?
        @title = "#{@json['asking_name']} asked:"
      else
        super
      end
    end
  end
end
