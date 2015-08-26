require 'test_helper'

class SitemapControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, format: :xml

    assert_response :success

    assert_not_nil assigns(:pages)

    assert_not_nil assigns(:posts)
  end
end
