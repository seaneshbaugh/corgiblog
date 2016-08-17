require 'test_helper'

module Tumblr
  class ChatTest < ActiveSupport::TestCase
    test 'it should use the chat title as the post title if it exists' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:chat, 90000000031))

      post = tumblr_post.to_post

      assert_equal 'What a waste of paper.', post.title
    end

    test 'it should create the body based on the dialogue' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:chat, 90000000030))

      post = tumblr_post.to_post

      expected_body = '<ul class="conversation">' \
                      '<li class="chat-odd">' \
                      '<span class="label">Casie:</span>' \
                      '&quot;I may quit out of rage fyi&quot;' \
                      '</li>' \
                      '<li class="chat-even">' \
                      '<span class="label">Casie:</span>' \
                      '&quot;😎&quot;' \
                      '</li>' \
                      '<li class="chat-odd">' \
                      '<span class="label">Sean:</span>' \
                      '&quot;give em hell&quot;' \
                      '</li>' \
                      '</ul>'

      assert_equal expected_body, post.body
    end
  end
end
