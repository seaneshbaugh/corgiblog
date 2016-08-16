require 'test_helper'

class PicturesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get pictures_url

    assert_response :success
  end

  test 'should get picture' do
    image = fixture_file_upload(File.join('images', 'friday.jpg'), 'image/jpeg')

    picture = Picture.create(title: 'Friday', image: image)

    get picture_url(id: picture)

    assert_response :success
  end
end
