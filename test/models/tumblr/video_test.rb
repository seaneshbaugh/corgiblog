require 'test_helper'

module Tumblr
  class VideoTest < ActiveSupport::TestCase
    test 'it should use the video source title as the post title' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:video, 16790104604))

      post = tumblr_post.to_post

      assert_equal 'conneythecorgi.com', post.title
    end

    test 'it should use the largest video embed code  and caption as the post body' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:video, 16790104604))

      post = tumblr_post.to_post

      expected_body = '<iframe width="500" height="375" id="youtube_iframe" ' \
                      'src="https://www.youtube.com/embed/Mkf4VEzgYS8?feature=oembed&amp;enablejsapi=1&amp;origin=https://safe.txmblr.com&amp;wmode=opaque" ' \
                      'frameborder="0" allowfullscreen>' \
                      '</iframe>' \
                      '<p>' \
                      '<a href="http://conneythecorgi.com/posts/conney-vs-the-orange-tabby">' \
                      'http://conneythecorgi.com/posts/conney-vs-the-orange-tabby' \
                      '</a>' \
                      '</p>'

      assert_equal expected_body, post.body
    end
  end
end
