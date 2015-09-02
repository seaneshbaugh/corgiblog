require 'test_helper'

module Tumblr
  class ChatTest < ActiveSupport::TestCase
    test 'it should use the chat title as the post title if it exists' do
      json = {
        'id' => 1234567890,
        'type' => 'chat',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'title' => 'lolwut',
        'body' => '',
        'dialogue' => [
          {
            'label' => 'Casie:',
            'name' => 'Casie',
            'phrase' => 'lol'
          },
          {
            'label' => 'Sean:',
            'name' => 'Sean',
            'phrase' => 'wut'
          }
        ]
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      assert_equal 'lolwut', post.title
    end

    test 'it should create the body based on the dialogue' do
      json = {
        'id' => 1234567890,
        'type' => 'chat',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'title' => 'lolwut',
        'body' => '',
        'dialogue' => [
          {
            'label' => 'Casie:',
            'name' => 'Casie',
            'phrase' => 'time to kaizen 😞'
          },
          {
            'label' => 'Sean:',
            'name' => 'Sean',
            'phrase' => '塊然'
          },
          {
            'label' => 'Sean:',
            'name' => 'Sean',
            'phrase' => 'so i just got some of the chocolate peanut caramel protein bars'
          },
          {
            'label' => 'Casie:',
            'name' => 'Casie',
            'phrase' => 'at least i figured it out before a drank another 3 days worth of decaffeinated coffee and had a headache'
          }
        ]
      }

      tumblr_post = Tumblr::PostFactory.new(json)

      post = tumblr_post.to_post

      expected_body = '<ul class="conversation">' +
                      '<li class="chat-odd">' +
                      '<span class="label">Casie:</span>' +
                      '&quot;time to kaizen 😞&quot;' +
                      '</li>' +
                      '<li class="chat-even">' +
                      '<span class="label">Sean:</span>' +
                      '&quot;塊然&quot;' +
                      '</li>' +
                      '<li class="chat-odd">' +
                      '<span class="label">Sean:</span>' +
                      '&quot;so i just got some of the chocolate peanut caramel protein bars&quot;' +
                      '</li>' +
                      '<li class="chat-even">' +
                      '<span class="label">Casie:</span>' +
                      '&quot;at least i figured it out before a drank another 3 days worth of decaffeinated coffee and had a headache&quot;' +
                      '</li>' +
                      '</ul>'

      assert_equal expected_body, post.body
    end
  end
end
