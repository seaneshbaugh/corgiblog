require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test 'it finds the first image in a page' do
    page = pages(:page_with_images)

    assert_equal 'http://conneythecorgi.com/image1.jpg', page.first_image
  end

  test 'published? should return whatever visible is' do
    page = Page.new(visible: false)

    assert_equal page.published?, false

    page.visible = true

    assert_equal page.published?, true
  end
end
