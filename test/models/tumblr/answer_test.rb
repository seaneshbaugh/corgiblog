require 'test_helper'

module Tumblr
  class AnswerTest < ActiveSupport::TestCase
    test 'it should use the asking name as the post title' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:answer, 90000000002))

      post = tumblr_post.to_post

      assert_equal 'seaneshbaugh asked:', post.title
    end

    test 'it should use the question and answer as the post body' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:answer, 90000000001))

      post = tumblr_post.to_post

      expected_body = '<div class="question">' \
                      '<p class="asker">' \
                      '<strong>seaneshbaugh</strong> asked:' \
                      '</p>' \
                      '<p class="question-text">' \
                      'Who is the best dog?' \
                      '</p>' \
                      '</div>' \
                      '<div class="answer">' \
                      '<p>Conney. <em>duh.<em></p>' \
                      '</div>'

      assert_equal expected_body, post.body
    end
  end
end
