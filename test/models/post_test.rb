require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'sticky_first should make sticky posts appear first' do
    posts = Post.sticky_first.reverse_chronological

    assert_equal 'Sticky Post', posts.first.title
  end

  test 'published? should return whatever visible is' do
    post = Post.new(visible: false)

    assert_equal post.published?, false

    post.visible = true

    assert_equal post.published?, true
  end
end
