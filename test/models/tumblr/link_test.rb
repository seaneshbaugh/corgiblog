require 'test_helper'

module Tumblr
  class LinkTest < ActiveSupport::TestCase
    test 'it should use the link title as the post title' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:link, 16468180085))

      post = tumblr_post.to_post

      assert_equal 'My review for Oak Hill Animal Rescue in Seagoville, TX. This is', post.title
    end

    test 'it should use the link description as the post body' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:link, 33515489745))

      post = tumblr_post.to_post

      assert_equal '<p>Ginger is #87!!!</p>', post.body
    end
  end
end
