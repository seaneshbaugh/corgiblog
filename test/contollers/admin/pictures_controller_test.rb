require 'test_helper'

module Admin
  class PicturesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should get index' do
      get admin_pictures_url

      assert_response :success
    end

    test 'should get new' do
      get new_admin_picture_url

      assert_response :success
    end

    test 'should create picture' do
      image = fixture_file_upload(File.join('images', 'friday.jpg'), 'image/jpeg')

      assert_difference('Picture.count') do
        post admin_pictures_url, params: { picture: { image: image, title: 'New Picture' } }
      end

      picture = Picture.last

      assert_redirected_to admin_picture_path(picture)
    end

    test 'should not create invalid picture' do
      assert_no_difference('Picture.count') do
        post admin_pictures_url, params: { picture: { title: 'Invalid Picture' } }
      end
    end

    test 'should show picture' do
      image = fixture_file_upload(File.join('images', 'friday.jpg'), 'image/jpeg')

      picture = Picture.create(title: 'Friday', image: image)

      get admin_picture_url(id: picture)

      assert_response :success
    end

    test 'should get edit' do
      image = fixture_file_upload(File.join('images', 'friday.jpg'), 'image/jpeg')

      picture = Picture.create(title: 'Friday', image: image)

      get edit_admin_picture_url(id: picture)

      assert_response :success
    end

    test 'should update picture' do
      image = fixture_file_upload(File.join('images', 'friday.jpg'), 'image/jpeg')

      picture = Picture.create(title: 'Friday', image: image)

      patch admin_picture_url(id: picture), params: { picture: { title: 'Updated Picture' } }

      picture.reload

      assert_redirected_to edit_admin_picture_path(picture)
    end

    test 'should not update picture with invalid data' do
      image = fixture_file_upload(File.join('images', 'friday.jpg'), 'image/jpeg')

      picture = Picture.create(title: 'Friday', image: image)

      patch admin_picture_url(id: picture), params: { picture: { title: '' } }

      picture.reload

      assert_not_equal picture.title, ''
    end

    test 'should destroy picture' do
      image = fixture_file_upload(File.join('images', 'friday.jpg'), 'image/jpeg')

      picture = Picture.create(title: 'Friday', image: image)

      assert_difference('Picture.count', -1) do
        delete admin_picture_url(id: picture)
      end

      assert_redirected_to admin_pictures_path
    end
  end
end
