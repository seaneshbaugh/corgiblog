require "truncate_html"

class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @posts = Post.published.page(params[:page]).order("created_at desc")
      end

      format.rss do
        @posts = Post.published.order("created_at desc")
        render :layout => false
      end
    end
  end

  def show
    @post = Post.find_by_slug(params[:id])

    if @post.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find"

      redirect_to root_url and return
    end

    @page_title = @post.title + " - Conney the Corgi!"
    @page_description = @post.meta_description
  end
end
