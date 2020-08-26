# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @posts = posts_for_html
      end

      format.rss do
        @posts = posts_for_rss
      end
    end
  end

  def show
    @post = Post.friendly.find(params[:id])

    raise ActiveRecord::RecordNotFound if @post.nil?
  end

  private

  def posts_for_html
    if params[:tag].present?
      Post.published.tagged_with(params[:tag]).includes(:user).page(params[:page]).per(25).reverse_chronological
    else
      Post.published.includes(:user).page(params[:page]).per(25).reverse_chronological
    end
  end

  def posts_for_rss
    Post.published.includes(:user).reverse_chronological
  end
end
