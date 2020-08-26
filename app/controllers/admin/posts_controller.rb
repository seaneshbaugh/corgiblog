# frozen_string_literal: true

module Admin
  class PostsController < AdminController
    before_action :set_post, only: %i[show edit update destroy]

    def index
      authorize Post

      @search = Post.ransack(params[:q])

      @posts = @search.result.page(params[:page]).per(25).reverse_chronological
    end

    def show
      authorize @post
    end

    def new
      authorize Post

      @post = Post.new
    end

    def edit
      authorize @post
    end

    def create
      authorize Post

      @post = Post.new(post_params)

      @post.user = current_user if @post.user.nil?

      if @post.save
        flash[:success] = t('.success')

        redirect_to admin_post_url(@post), status: :see_other
      else
        flash[:error] = helpers.error_messages_for(@post)

        render 'new', status: :unprocessable_entity
      end
    end

    def update
      authorize @post

      if @post.update(post_params)
        flash[:success] = t('.success')

        redirect_to edit_admin_post_url(@post), status: :see_other
      else
        flash[:error] = helpers.error_messages_for(@post)

        render 'edit', status: :unprocessable_entity
      end
    end

    def destroy
      authorize @post

      @post.destroy

      flash[:success] = t('.success')

      redirect_to admin_posts_url, status: :see_other
    end

    private

    def set_post
      @post = Post.friendly.find(params[:id])

      raise ActiveRecord::RecordNotFound if @post.nil?
    end

    def post_params
      params.require(:post).permit(:user_id, :title, :body, :style, :script, :meta_description, :meta_keywords, :visible)
    end
  end
end
