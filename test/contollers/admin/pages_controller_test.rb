require 'test_helper'

module Admin
  class PagesControllerTest < ActionController::TestCase
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should get index' do
      get :index

      assert_response :success

      assert_not_nil assigns(:pages)
    end

    test 'should get new' do
      get :new

      assert_response :success
    end

    test 'should create page' do
      assert_difference('Page.count') do
        post :create, page: { title: 'New Page' }
      end

      assert_redirected_to admin_page_path(assigns(:page))
    end

    test 'should not create invalid page' do
      assert_no_difference('Page.count') do
        post :create, page: { title: '' }
      end

      assert_template :new
    end

    test 'should show page' do
      page = pages(:about)

      get :show, id: page

      assert_response :success
    end

    test 'should get edit' do
      page = pages(:about)

      get :edit, id: page

      assert_response :success
    end

    test 'should update page' do
      page = pages(:about)

      patch :update, id: page, page: { name: 'Updated Page' }

      assert_redirected_to edit_admin_page_path(assigns(:page))
    end

    test 'should not update page with invalid data' do
      page = pages(:about)

      patch :update, id: page, page: { title: '' }

      assert_template :edit
    end

    test 'should destroy page' do
      page = pages(:about)

      assert_difference('Page.count', -1) do
        delete :destroy, id: page
      end

      assert_redirected_to admin_pages_path
    end
  end
end
