class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        if params[:q].present? && params[:q][:s].present?
          @search = Post.unscoped.search(params[:q])
        else
          @search = Post.search(params[:q])
        end

        @posts = @search.result.published.page(params[:page])
      end

      format.rss do
        @posts = Post.published
        render :layout => false
      end
    end
  end

  def show
    @post = Post.where(:slug => params[:id]).first

    if @post.nil?
      flash[:type] = "error"

      flash[:notice] = t('messages.posts.could_not_find')

      redirect_to root_url and return
    end

    @page_title = "#{@post.title} - #{t('application.title')}"
    @page_description = @post.meta_description
  end
end
