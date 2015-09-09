require 'test_helper'

module Tumblr
  class TextTest < ActiveSupport::TestCase
    test 'it should use a title as the title' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:text, 17628552018))

      post = tumblr_post.to_post

      assert_equal 'I know my converse are like 10 yrs old (why I use them when', post.title
    end

    test 'it should use the body as the body' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:text, 19464345373))

      post = tumblr_post.to_post

      expected_body = '<p>' \
                      '<a class="tumblr_blog" href="http://emmathebean.com/post/19463302839/to-everyone-in-dallas">emmathebean</a>:' \
                      '</p> ' \
                      '<blockquote> ' \
                      '<p>' \
                      'If you have a Corgi come out to Lewisville Railroad Park @ 4 today. ' \
                      'The North Texas Corgi Owner group from MyCorgi is getting together.' \
                      '</p> ' \
                      '<p>' \
                      'We are meeting in the large dog section, in the back area.' \
                      '</p> ' \
                      '</blockquote>'

      assert_equal expected_body, post.body
    end
  end
end
