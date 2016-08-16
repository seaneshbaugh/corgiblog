require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get page' do
    page = pages(:about)

    get page_url(id: page)

    assert_response :success
  end
end
