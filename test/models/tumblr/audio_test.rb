require 'test_helper'

module Tumblr
  class AudioTest < ActiveSupport::TestCase
    test 'it should use the audio artist and track name if both are present as the post title' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:audio, 90000000012))

      post = tumblr_post.to_post

      assert_equal 'Conney the Corgi - Squirrel?', post.title
    end

    test 'it should use just the track name if no artist is present as the post title' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:audio, 90000000010))

      post = tumblr_post.to_post

      assert_equal "Conney the Corgi - I'm Gonna Take Your Spot on the Couch", post.title
    end

    test 'it should use the audio player and caption as the post body' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:audio, 90000000011))

      post = tumblr_post.to_post

      expected_body = "<embed type=\"application/x-shockwave-flash\" " \
                      "src=\"https://secure.assets.tumblr.com/swf/audio_player.swf?" \
                      "audio_file=https%3A%2F%2Fwww.tumblr.com%2Faudio_file%2Fconneythecorgi%2F90000000011%2Ftumblr_GiBIpP1tERl6mUCyr" \
                      "&color=FFFFFF\" height=\"27\" width=\"207\" quality=\"best\" wmode=\"opaque\">" \
                      '</embed>' \
                      '<p>Woof woof!</p>'

      assert_equal expected_body, post.body
    end
  end
end
