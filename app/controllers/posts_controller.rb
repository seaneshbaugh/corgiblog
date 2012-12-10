class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @posts = Post.where(:visible => true).page(params[:page]).per(25).order('created_at DESC')
      end

      format.rss do
        @posts = Post.where(:visible => true).order('created_at DESC')
      end
    end
  end

  def show
    @post = Post.where(:slug => params[:id], :visible => true).first

    if @post.nil?
      flash[:error] = t('messages.posts.could_not_find')

      redirect_to root_url
    end
  end
end
