require 'test_helper'

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should get index' do
      get admin_users_url

      assert_response :success
    end

    test 'should get new' do
      get new_admin_user_url

      assert_response :success
    end

    test 'should create user' do
      assert_difference('User.count') do
        post admin_users_url, params: { user: { email: 'new@user.com', password: 'changeme', password_confirmation: 'changeme', role: 'admin', first_name: 'New', last_name: 'User' } }
      end

      user = User.last

      assert_redirected_to admin_user_path(user)
    end

    test 'should not create invalid user' do
      assert_no_difference('User.count') do
        post admin_users_url, params: { user: { email: '' } }
      end
    end

    test 'should show user' do
      user = users(:casie_clark)

      get admin_user_url(id: user)

      assert_response :success
    end

    test 'should get edit' do
      user = users(:casie_clark)

      get edit_admin_user_url(id: user)

      assert_response :success
    end

    test 'should update user' do
      user = users(:casie_clark)

      patch admin_user_url(id: user), params: { user: { email: 'case@casie.com' } }

      user.reload

      assert_redirected_to edit_admin_user_path(user)
    end

    test 'should not update user with invalid data' do
      user = users(:casie_clark)

      patch admin_user_url(id: user), params: { user: { email: '' } }

      user.reload

      assert_not_equal user.email, ''
    end

    test 'should destroy user' do
      user = users(:casie_clark)

      assert_difference('User.count', -1) do
        delete admin_user_url(id: user)
      end

      assert_redirected_to admin_users_path
    end
  end
end
