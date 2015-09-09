require 'test_helper'

class OptionsForSelectTest < ActiveSupport::TestCase
  test 'it should return a list of options for all instances of a model' do
    first_post = posts(:first_post)

    second_post = posts(:second_post)

    assert_equal Post.options_for_select, [[first_post.title, first_post.id], [second_post.title, second_post.id]]
  end
end
