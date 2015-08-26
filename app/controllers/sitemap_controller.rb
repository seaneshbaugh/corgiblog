class SitemapController < ApplicationController
  def index
    @pages = Page.published.by_order

    @posts = Post.published.reverse_chronological

    respond_to do |format|
      format.xml do
        render layout: false

        headers['Content-Type'] = 'application/xml'
      end
    end
  end
end
