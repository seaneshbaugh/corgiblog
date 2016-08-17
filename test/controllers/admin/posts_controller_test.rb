require 'test_helper'

module Admin
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:sean_eshbaugh)
    end

    test 'should get index' do
      get admin_posts_url

      assert_response :success
    end

    test 'should get new' do
      get new_admin_post_url

      assert_response :success
    end

    test 'should create post' do
      assert_difference('Post.count') do
        post admin_posts_url, params: { post: { title: 'New Post' } }
      end

      post = Post.last

      assert_redirected_to admin_post_path(post)
    end

    test 'should not create invalid post' do
      assert_no_difference('Post.count') do
        post admin_posts_url, params: { post: { title: '' } }
      end
    end

    test 'should show post' do
      post = posts(:first_post)

      get admin_post_url(id: post)

      assert_response :success
    end

    test 'should get edit' do
      post = posts(:first_post)

      get edit_admin_post_url(id: post)

      assert_response :success
    end

    test 'should not get edit if current_user is admin and post was made by sysadmin' do
      sign_in users(:casie_clark)

      post = posts(:first_post)

      get edit_admin_post_url(id: post)

      assert_redirected_to root_path

      assert_equal flash[:error], 'You are not authorized to access this page.'
    end

    test 'should get edit if current_user is admin and post was made by another admin' do
      sign_in users(:casie_clark)

      other_admin = users(:conney_the_corgi)

      other_admin.admin!

      other_admin.save!

      post = posts(:first_post)

      post.user = other_admin

      post.save!

      get edit_admin_post_url(id: post)

      assert_redirected_to root_path

      assert_equal flash[:error], 'You are not authorized to access this page.'
    end

    test 'should update post' do
      post = posts(:first_post)

      patch admin_post_url(id: post), params: { post: { name: 'Updated Post' } }

      post.reload

      assert_redirected_to edit_admin_post_path(post)
    end

    test 'should not update post with invalid data' do
      post = posts(:first_post)

      patch admin_post_url(id: post), params: { post: { title: '' } }

      post.reload

      assert_not_equal post.title, ''
    end

    test 'should not update post if current_user is admin and post was made by sysadmin' do
      sign_in users(:casie_clark)

      post = posts(:first_post)

      patch admin_post_url(id: post), params: { post: { name: 'Updated Post' } }

      assert_redirected_to root_path

      assert_equal flash[:error], 'You are not authorized to access this page.'
    end

    test 'should not update post if current_user is admin and post was made by another admin' do
      sign_in users(:casie_clark)

      other_admin = users(:conney_the_corgi)

      other_admin.admin!

      other_admin.save!

      post = posts(:first_post)

      post.user = other_admin

      post.save!

      patch admin_post_url(id: post), params: { post: { name: 'Updated Post' } }

      assert_redirected_to root_path

      assert_equal flash[:error], 'You are not authorized to access this page.'
    end

    test 'should destroy post' do
      post = posts(:first_post)

      assert_difference('Post.count', -1) do
        delete admin_post_url(id: post)
      end

      assert_redirected_to admin_posts_path
    end
  end
end
