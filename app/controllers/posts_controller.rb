class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        if params[:tag].present?
          @posts = Post.published.tagged_with(params[:tag]).includes(:user, :tags).page(params[:page]).per(25).sticky_first.reverse_chronological
        else
          @posts = Post.published.includes(:user, :tags).page(params[:page]).per(25).sticky_first.reverse_chronological
        end
      end

      format.rss do
        @posts = Post.published.includes(:user).reverse_chronological
      end
    end
  end

  def show
    @post = Post.published.where(slug: params[:id]).first

    fail ActiveRecord::RecordNotFound if @post.nil?
  end
end
