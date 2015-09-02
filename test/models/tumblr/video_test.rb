require 'test_helper'

module Tumblr
  class VideoTest < ActiveSupport::TestCase
    test 'it should use the video source title as the post title' do
      json = {
        'id' => 1234567890,
        'type' => 'video',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'source_title' => 'Video Post',
        'caption' => '<p>Watch!</p>',
        'player' => '<div class="player"></div>'
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      assert_equal 'Video Post', post.title
    end

    test 'it should use the video player and caption as the post body' do
      json = {
        'id' => 1234567890,
        'type' => 'video',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'source_title' => 'Video Post',
        'caption' => '<p>Watch!</p>',
        'player' => '<div class="player"></div>'
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      assert_equal '<div class="player"></div><p>Watch!</p>', post.body
    end
  end
end
