require 'test_helper'

module Tumblr
  class AnswerTest < ActiveSupport::TestCase
    test 'it should use the asking name as the post title' do
      json = {
        'id' => 1234567890,
        'type' => 'answer',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'asking_name' => 'Sean',
        'asking_url' => 'http://seaneshbaugh.com/',
        'question' => 'Who is the best dog ever?',
        'answer' => '<p>Conney is, <strong>duh</strong>.</p>'
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      assert_equal 'Sean asked:', post.title
    end

    test 'it should use the question and answer as the post body' do
      json = {
        'id' => 1234567890,
        'type' => 'answer',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'asking_name' => 'Sean',
        'asking_url' => 'http://seaneshbaugh.com/',
        'question' => 'Wiggle butt?',
        'answer' => '<p><em>Wiggle butt.</em></p>'
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      expected_body = '<div class="question">' +
                      '<p class="asker">' +
                      '<strong>Sean</strong> asked:' +
                      '</p>' +
                      '<p class="question-text">' +
                      'Wiggle butt?' +
                      '</p>' +
                      '</div>' +
                      '<div class="answer">' +
                      '<p><em>Wiggle butt.</em></p>' +
                      '</div>'

      assert_equal expected_body, post.body
    end
  end
end
