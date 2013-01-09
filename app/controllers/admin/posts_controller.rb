class Admin::PostsController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = Post.unscoped.search(params[:q])
    else
      @search = Post.search(params[:q])
    end

    @posts = @search.result.page(params[:page]).order('posts.created_at DESC').per(25)
  end

  def show
    @post = Post.where(:slug => params[:id]).first

    if @post.nil?
      flash[:error] = t('messages.posts.could_not_find')

      redirect_to admin_pages_url
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])

    if !(current_user.sysadmin? || current_user.admin?) || @post.user.nil?
      @post.user = current_user
    end

    if @post.save
      flash[:success] = t('messages.posts.created')

      if params[:redirect_to_new].present?
        redirect_to new_admin_post_url
      else
        redirect_to admin_posts_url
      end
    else
      flash[:error] = @post.errors.full_messages.uniq.join('. ') + '.'

      render 'new'
    end
  end

  def edit
    @post = Post.where(:slug => params[:id]).first

    if @post.nil?
      flash[:error] = t('messages.posts.could_not_find')

      redirect_to admin_postss_url
    end
  end

  def update
    @post = Post.where(:slug => params[:id]).first

    if @post.nil?
      flash[:error] = t('messages.posts.could_not_find')

      redirect_to admin_posts_url and return
    end

    if !(current_user.sysadmin? || current_user.admin?) || @post.user.nil?
      @post.user = current_user
    end

    if @post.update_attributes(params[:post])
      flash[:success] = t('messages.posts.updated')

      redirect_to edit_admin_post_url(@post)
    else
      flash[:error] = @post.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def destroy
    @post = Post.where(:slug => params[:id]).first

    if @post.nil?
      flash[:error] = t('messages.posts.could_not_find')

      redirect_to admin_posts_url and return
    end

    @post.destroy

    flash[:success] = t('messages.posts.deleted')

    redirect_to admin_posts_url
  end
end
