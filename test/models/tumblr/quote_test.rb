require 'test_helper'

module Tumblr
  class QuoteTest < ActiveSupport::TestCase
    test 'it should use a truncated version of the text as the title' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:quote, 90000000021))

      post = tumblr_post.to_post

      assert_equal 'Death is certain, replacing both the siren-song of Paradise and', post.title
    end

    test 'it should return a blockquote as the body' do
      tumblr_post = Tumblr::PostFactory.new(tumblr_json(:quote, 90000000022))

      post = tumblr_post.to_post

      expected_body = '<blockquote class="tumblr-quote">' \
                      '<p class="tumblr-quote-text">' \
                      'Everything alive will die someday. ' \
                      'But in the meantime I got to see her smile, and that made it OK for awhile. ' \
                      'To look into her eyes was worth the eventual demise of earth.' \
                      '</p>' \
                      '<cite class="tumblr-quote-source"> ' \
                      '&mdash; ' \
                      '<p>' \
                      '<a href="http://en.wikipedia.org/wiki/George_Hrab" target="_blank">George Hrab</a> ' \
                      '(via <a href="http://www.sgutranscripts.org/wiki/SGU_Episode_282#Quote_of_the_Week_.28.29" ' \
                      'class="tumblr_blog" target="_blank">' \
                      'The Skeptics Guide to the Universe: Episode 282 Quote of the Week</a>)' \
                      '</p>' \
                      '</cite>' \
                      '</blockquote>'

      assert_equal expected_body, post.body
    end
  end
end
