require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url

    assert_response :success
  end

  test 'should get index RSS feed' do
    get posts_url(format: :rss)

    assert_response :success
  end

  test 'should get an individual post' do
    post = posts(:first_post)

    get post_url(id: post)

    assert_response :success
  end
end
