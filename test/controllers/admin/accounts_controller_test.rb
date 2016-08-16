require 'test_helper'

module Admin
  class AccountsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should show the current users account' do
      get admin_account_url

      assert_response :success
    end

    test 'should get edit' do
      get edit_admin_account_url

      assert_response :success
    end

    test 'should update the current users account' do
      patch admin_account_url, params: { account: { first_name: 'Test' } }

      assert_redirected_to admin_account_url

      controller.current_user.reload

      assert_equal controller.current_user.first_name, 'Test'
    end
  end
end
