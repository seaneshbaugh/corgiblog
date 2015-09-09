require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test 'it finds the first image in a page' do
    page = pages(:page_with_images)

    assert_equal 'http://conneythecorgi.com/image1.jpg', page.first_image
  end
end
