require 'test_helper'

module Tumblr
  class PhotoTest < ActiveSupport::TestCase

    test 'it should use the photo title as the post title' do
      VCR.use_cassette('tumblr photos test 1') do
        tumblr_post = Tumblr::PostFactory.new(tumblr_json(:photo, 123246991384))

        tumblr_post.download_photos!

        post = tumblr_post.to_post

        assert_equal 'This is a safe place to hide from fireworks, right?', post.title
      end
    end

    test 'it should use the photo caption as the post body' do
      VCR.use_cassette('tumblr photos test 2') do
        tumblr_post = Tumblr::PostFactory.new(tumblr_json(:photo, 123516808324))

        tumblr_post.download_photos!

        post = tumblr_post.to_post

        expected_body = '<p class="center">' \
                        '<a href="/uploads/pictures/test/\d{16}.jpg">' \
                        '<img alt="Hurry up, human\. It\'s time for my walk." src="/uploads/pictures/test/medium_\d{16}.jpg" title="Hurry up, human. It\'s time for my walk.">' \
                        '</a>' \
                        '</p>' \
                        '<p>Hurry up, human. It\'s time for my walk.</p>'

        assert_match Regexp.new(expected_body), post.body
      end
    end
  end
end
