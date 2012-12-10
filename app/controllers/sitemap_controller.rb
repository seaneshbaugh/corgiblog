class SitemapController < ApplicationController
  def index
    @pages = Page.where(:visible => true).order('pages.order ASC')

    @posts = Post.where(:visible => true).order('created_at DESC')

    respond_to do |format|
      format.xml do
        render :layout => false

        headers["Content-Type"] = "application/xml"
      end
    end
  end
end
