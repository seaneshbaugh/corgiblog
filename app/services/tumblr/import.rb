require 'oauth'

module Tumblr
  class Import
    OAUTH_SETTINGS = {
      site: 'http://www.tumblr.com',
      request_token_path: '/oauth/request_token',
      authorize_path: '/oauth/authorize',
      access_token_path: '/oauth/access_token',
      http_method: :post
    }

    def self.call
      get_oauth_token

      get_client

      get_posts

      download_photos!

      save_and_update_posts!
    end

    protected

    def self.get_client
      Tumblr.configure do |config|
        config.consumer_key = ENV['TUMBLR_CONSUMER_KEY']
        config.consumer_secret = ENV['TUMBLR_CONSUMER_SECRET']
        config.oauth_token = @oauth_token
        config.oauth_token_secret = @oauth_token_secret
      end

      @client = Tumblr::Client.new(client: :httpclient)
    end

    def self.get_oauth_token
      consumer = OAuth::Consumer.new(ENV['TUMBLR_CONSUMER_KEY'], ENV['TUMBLR_CONSUMER_SECRET'], OAUTH_SETTINGS)

      request_token = consumer.get_request_token(exclude_callback: true)

      @oauth_token = request_token.params[:oauth_token]

      @oauth_token_secret = request_token.params[:oauth_token_secret]
    end

    def self.get_posts
      @tumblr_posts = []

      offset = 0

      loop do
        tumblr_posts_json = @client.posts(ENV['TUMBLR_BLOG_URI'], offset: offset)['posts']

        @tumblr_posts += tumblr_posts_json.map { |post_json| Tumblr::PostFactory.new(post_json) }

        offset += 20

        # break unless posts.present?
        break
      end

      @tumblr_posts
    end

    def self.download_photos!
      @tumblr_posts.each do |tumblr_post|
        tumblr_post.download_photos!
      end
    end

    def self.save_and_update_posts!
      @tumblr_posts.each do |tumblr_post|
        post = tumblr_post.to_post

        post.save!
      end
    end
  end
end
