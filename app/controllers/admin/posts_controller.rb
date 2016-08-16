module Admin
  class PostsController < AdminController
    before_action :set_post, only: [:show, :edit, :update, :destroy]

    authorize_resource

    def index
      @search = Post.search(params[:q])

      @posts = @search.result.includes(:user).page(params[:page]).per(25).reverse_chronological

      @deleted_posts = PaperTrail::Version.destroys.where(item_type: 'Post').reorder('versions.created_at DESC')
    end

    def show
      @previous_versions = @post.versions.updates.reorder('versions.created_at DESC')
    end

    def new
      @post = Post.new
    end

    def edit
    end

    def create
      @post = Post.new(post_params)

      if !(current_user.sysadmin? || current_user.admin?) || @post.user.nil?
        @post.user = current_user
      end

      if @post.save
        flash[:success] = 'Post was successfully created.'

        redirect_to admin_post_url(@post)
      else
        flash.now[:error] = view_context.error_messages_for(@post)

        render 'new'
      end
    end

    def update
      if !current_user.sysadmin? && !current_user.admin? && @post.user != current_user
        flash[:error] = 'You cannot edit another user\'s posts.'

        redirect_to admin_posts_url and return
      end

      if @post.update(post_params)
        flash[:success] = 'Post was successfully updated.'

        redirect_to edit_admin_post_url(@post)
      else
        flash.now[:error] = view_context.error_messages_for(@post)

        render 'edit'
      end
    end

    def destroy
      if !current_user.sysadmin? && !current_user.admin? && @post.user != current_user
        flash[:error] = 'You cannot delete another user\'s posts.'

        redirect_to admin_posts_url and return
      end

      @post.destroy

      flash[:success] = 'Post was successfully deleted.'

      redirect_to admin_posts_url
    end

    private

    def set_post
      @post = Post.where(slug: params[:id]).first

      fail ActiveRecord::RecordNotFound if @post.nil?
    end

    def post_params
      params.require(:post).permit(:title, :body, :style, :meta_description, :meta_keywords, :visible, :sticky, :tumblr_id, :tag_list)
    end
  end
end
