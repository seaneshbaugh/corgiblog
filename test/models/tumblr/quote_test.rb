require 'test_helper'

module Tumblr
  class QuoteTest < ActiveSupport::TestCase
    test 'it should return a blockquote as the body' do
      json = {
        'id' => 1234567890,
        'type' => 'quote',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'text' => "You see, I can live with doubt, and uncertainty, and not knowing. I think it's much more interesting to live not knowing, than to have answers that might be wrong. I have approximate answers, and possible beliefs, and different degrees of certainty about different things, but I'm not absolutely sure about anything, and many things I don't know anything about, such as whether it means anything to ask, &quot;why are we here?&quot;... But I don't have to have an answer; I don't feel frightened by not knowing things.",
        'source' => '<a href="https://en.wikipedia.org/wiki/Richard_Feynman" target="_blank">Richard Feynman</a> (via <a href="http://www.sgutranscripts.org/wiki/SGU_Episode_181#Quote_of_the_Week_.28.29" target="_blank">The Skeptics Guide to the Universe: Episode 181 Quote of the Week</a>)'
      }

      post = Tumblr::PostFactory.new(json)

      assert_equal "<blockquote class=\"tumblr-quote\"><p class=\"tumblr-quote-text\">You see, I can live with doubt, and uncertainty, and not knowing. I think it's much more interesting to live not knowing, than to have answers that might be wrong. I have approximate answers, and possible beliefs, and different degrees of certainty about different things, but I'm not absolutely sure about anything, and many things I don't know anything about, such as whether it means anything to ask, &quot;why are we here?&quot;... But I don't have to have an answer; I don't feel frightened by not knowing things.</p><cite class=\"tumblr-quote-source\"> &mdash; <a href=\"https://en.wikipedia.org/wiki/Richard_Feynman\" target=\"_blank\">Richard Feynman</a> (via <a href=\"http://www.sgutranscripts.org/wiki/SGU_Episode_181#Quote_of_the_Week_.28.29\" target=\"_blank\">The Skeptics Guide to the Universe: Episode 181 Quote of the Week</a>)</cite></blockquote>", post.to_post.body
    end

    test 'it should use a truncated version of the text as the title' do
            json = {
        'id' => 1234567890,
        'type' => 'quote',
        'date' => '2015-08-24 21:59:07 GMT',
        'tags' => [],
        'text' => "Accepting death &mdash; by understanding that every life comes to an end, when time demands it. Loss of life is to be mourned, but only if the life was wasted.",
        'source' => '<a href="https://en.wikipedia.org/wiki/Spock" target="_blank">Spock</a> (via <a href="http://www.sgutranscripts.org/wiki/SGU_Episode_504#Skeptical_Quote_of_the_Week_.281:25:30.29" target="_blank">The Skeptics Guide to the Universe: Episode 504 Quote of the Week</a>)'
      }

      post = Tumblr::PostFactory.new(json)

      assert_equal 'Accepting death &mdash; by understanding', post.to_post.title
    end
  end
end
