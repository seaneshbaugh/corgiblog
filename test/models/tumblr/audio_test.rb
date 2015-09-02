require 'test_helper'

module Tumblr
  class AudioTest < ActiveSupport::TestCase
    test 'it should use the audio source  title as the post title' do
      json = {
        'id' => 1234567890,
        'type' => 'audio',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'source_title' => 'Audio Post',
        'caption' => '<p>Listen!</p>',
        'player' => '<div class="player"></div>'
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      assert_equal 'Audio Post', post.title
    end

        test 'it should use the audio player and caption as the post body' do
      json = {
        'id' => 1234567890,
        'type' => 'audio',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'source_title' => 'Audio Post',
        'caption' => '<p>Listen!</p>',
        'player' => '<div class="player"></div>'
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      assert_equal '<div class="player"></div><p>Listen!</p>', post.body
    end
  end
end
