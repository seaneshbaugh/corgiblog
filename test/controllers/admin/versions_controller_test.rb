require 'test_helper'

module Admin
  class VersionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should get index' do
      get admin_versions_url

      assert_response :success
    end
  end
end
