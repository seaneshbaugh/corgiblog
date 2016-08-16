require 'test_helper'

module Admin
  class PagesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should get index' do
      get admin_pages_url

      assert_response :success
    end

    test 'should get new' do
      get new_admin_page_url

      assert_response :success
    end

    test 'should create page' do
      assert_difference('Page.count') do
        post admin_pages_url, params: { page: { title: 'New Page' } }
      end

      page = Page.last

      assert_redirected_to admin_page_path(page)
    end

    test 'should not create invalid page' do
      assert_no_difference('Page.count') do
        post admin_pages_url, params: { page: { title: '' } }
      end
    end

    test 'should show page' do
      page = pages(:about)

      get admin_page_url(id: page)

      assert_response :success
    end

    test 'should get edit' do
      page = pages(:about)

      get edit_admin_page_url(id: page)

      assert_response :success
    end

    test 'should update page' do
      page = pages(:about)

      patch admin_page_url(id: page), params: { page: { name: 'Updated Page' } }

      page.reload

      assert_redirected_to edit_admin_page_path(page)
    end

    test 'should not update page with invalid data' do
      page = pages(:about)

      patch admin_page_url(id: page), params: { page: { title: '' } }

      page.reload

      assert_not_equal page.title, ''
    end

    test 'should destroy page' do
      page = pages(:about)

      assert_difference('Page.count', -1) do
        delete admin_page_url(id: page)
      end

      assert_redirected_to admin_pages_path
    end
  end
end
