require 'test_helper'

module Tumblr
  class PostFactoryTest < ActiveSupport::TestCase
    def create_picture(filename, attributes)
      image = fixture_file_upload(filename, 'image/jpg')

      Picture.create(attributes.merge(image: image))
    end

    test 'it should not allow invalid post types to be created' do
      json = {
        'type' => 'invalid'
      }

      error = assert_raises ArgumentError do
        PostFactory.new(json)
      end

      assert_equal 'Unknown post type "invalid".', error.message
    end

    test 'it should not allow nil post types to be created' do
      json = {}

      error = assert_raises ArgumentError do
        PostFactory.new(json)
      end

      assert_equal 'Unknown post type nil.', error.message
    end

    test 'it should download photos from tumblr' do
      VCR.use_cassette('tumblr post factory test 1') do
        json = {
          'id' => 1234567890,
          'type' => 'photo',
          'date' => '2015-08-24 21:59:07 GMT',
          'caption' => '<p>Friday!</p>',
          'photos' => [
            {
              'caption' => '',
              'original_size' => {
                'width' => 640,
                'height' => 640,
                'url' => 'http://41.media.tumblr.com/104f17db6c48f7de41775c10d4e6da35/tumblr_nott7nUuOv1r9wamzo1_1280.jpg'
              }
            }
          ]
        }

        post = Tumblr::PostFactory.new(json)

        assert_equal 0, Picture.count

        photos = post.download_photos!

        assert_equal photos.length, 1

        assert_equal 1, Picture.count

        assert_equal '0c468b2e48c11599359bb72c2019442c', photos.first.image_fingerprint
      end
    end

    test 'it should skip existing picutres' do
      VCR.use_cassette('tumblr post factory test 2') do
        assert_equal 0, Picture.count

        existing_picture = create_picture('images/friday.jpg', title: 'Friday!')

        assert_equal 1, Picture.count

        json = {
          'id' => 1234567890,
          'type' => 'photo',
          'date' => '2015-08-24 21:59:07 GMT',
          'caption' => '<p>Friday!</p>',
          'photos' => [
            {
              'caption' => '',
              'original_size' => {
                'width' => 640,
                'height' => 640,
                'url' => 'http://41.media.tumblr.com/104f17db6c48f7de41775c10d4e6da35/tumblr_nott7nUuOv1r9wamzo1_1280.jpg'
              }
            },
            {
              'caption' => '',
              'original_size' => {
                'width' => 960,
                'height' => 1280,
                'url' => 'http://40.media.tumblr.com/eb3de79a7383331a0cbf4aa2e836c058/tumblr_nq7q7pz8X91r9wamzo1_1280.jpg'
              }
            }
          ]
        }

        post = Tumblr::PostFactory.new(json)

        photos = post.download_photos!

        assert_equal 2, photos.length

        assert_equal 2, Picture.count

        assert_equal existing_picture.id, photos.last.id

        assert_equal existing_picture.image_fingerprint, photos.last.image_fingerprint
      end
    end

    test 'it should deduplicate post titles' do
      VCR.use_cassette('tumblr post factory test 2') do
        first_json = {
          'id' => 1234567890,
          'type' => 'photo',
          'date' => '2015-08-24 21:59:07 GMT',
          'caption' => '<p>Friday!</p>',
          'photos' => [
            {
              'caption' => '',
              'original_size' => {
                'width' => 640,
                'height' => 640,
                'url' => 'http://41.media.tumblr.com/104f17db6c48f7de41775c10d4e6da35/tumblr_nott7nUuOv1r9wamzo1_1280.jpg'
              }
            }
          ]
        }

        second_json = {
          'id' => 1234567891,
          'type' => 'photo',
          'date' => '2015-08-24 21:59:10 GMT',
          'caption' => '<p>Friday!</p>',
          'photos' => [
            {
              'caption' => '',
              'original_size' => {
                'width' => 960,
                'height' => 1280,
                'url' => 'http://40.media.tumblr.com/eb3de79a7383331a0cbf4aa2e836c058/tumblr_nq7q7pz8X91r9wamzo1_1280.jpg'
              }
            }
          ]
        }

        first_tumblr_post = Tumblr::PostFactory.new(first_json)

        second_tumblr_post = Tumblr::PostFactory.new(second_json)

        first_tumblr_post.download_photos!

        second_tumblr_post.download_photos!

        first_post = first_tumblr_post.to_post

        first_post.save!

        second_post = second_tumblr_post.to_post

        second_post.save!

        assert_equal 'Friday!', first_post.title

        assert_equal 'Friday! 1', second_post.title
      end
    end


    test 'it should handle invalid dates' do
      VCR.use_cassette('tumblr post factory test 2') do
        post_json = {
          'id' => 1234567890,
          'type' => 'photo',
          'date' => 'INVALID',
          'caption' => '<p>Friday!</p>',
          'photos' => [
            {
              'caption' => '',
              'original_size' => {
                'width' => 640,
                'height' => 640,
                'url' => 'http://41.media.tumblr.com/104f17db6c48f7de41775c10d4e6da35/tumblr_nott7nUuOv1r9wamzo1_1280.jpg'
              }
            }
          ]
        }

        tumblr_post = Tumblr::PostFactory.new(post_json)

        post = tumblr_post.to_post

        post.save!

        assert_equal 'Friday!', post.title
      end
    end
  end
end
