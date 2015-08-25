class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        if params[:tag].present?
          @posts = Post.published.tagged_with(params[:tag]).includes(:user).page(params[:page]).per(25).reverse_chronological
        else
          @posts = Post.published.includes(:user).page(params[:page]).per(25).reverse_chronological
        end
      end

      format.rss do
        @posts = Post.published.includes(:user).reverse_chronological
      end
    end
  end

  def show
    @post = Post.published.where(slug: params[:id]).first

    if @post.nil?
      flash[:error] = t('messages.posts.could_not_find')

      redirect_to root_url
    end
  end
end
