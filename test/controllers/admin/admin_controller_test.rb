require 'test_helper'

module Admin
  class AdminControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should get the admin root' do
      get admin_root_url

      assert_response :success
    end
  end
end
