require 'test_helper'

module Admin
  class VersionsControllerTest < ActionController::TestCase
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should get index' do
      get :index

      assert_response :success

      assert_not_nil assigns(:versions)
    end
  end
end
