require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'published? should return whatever visible is' do
    post = Post.new(visible: false)

    assert_equal post.published?, false

    post.visible = true

    assert_equal post.published?, true
  end
end
