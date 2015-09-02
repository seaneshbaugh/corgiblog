require 'test_helper'

module Tumblr
  class LinkTest < ActiveSupport::TestCase
    test 'it should use the link title as the post title' do
      json = {
        'id' => 1234567890,
        'type' => 'link',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'title' => 'The Last Question',
        'url' => 'http://web.archive.org/web/20040815203832/http://www.ecf.utoronto.ca/~ngn/misc/last.html',
        'author' => 'Isaac Asimov',
        'excerpt' => 'The last question was asked for the first time, half in jest, on May 21, 2061',
        'publisher' => 'web.archive.org',
        'description' => '<p>My favorite short story.</p>'
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      assert_equal 'The Last Question', post.title
    end

    test 'it should use the link description as the post body' do
      json = {
        'id' => 1234567890,
        'type' => 'link',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'title' => "They're Made Out of Meat",
        'url' => 'http://www.terrybisson.com/page6/page6.html',
        'author' => 'Terry Bisson',
        'excerpt' => "&quot;They're made out of meat.&quot;",
        'publisher' => 'terrybisson.com',
        'description' => '<p>They talk by flapping their meat at each other.</p>'
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      assert_equal '<p>They talk by flapping their meat at each other.</p>', post.body
    end
  end
end
