class Admin::PostsController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = Post.unscoped.search(params[:q])
    else
      @search = Post.search(params[:q])
    end

    @posts = @search.result.page(params[:page]).order('created_at DESC')
  end

  def show
    @post = Post.where(:slug => params[:id]).first

    if @post.nil?
      redirect_to admin_posts_url, :notice => t('messages.posts.could_not_find')
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
      redirect_to admin_posts_url, :notice => t('messages.posts.created')
    else
      render 'new'
    end
  end

  def edit
    @post = Post.where(:slug => params[:id]).first

    if @post.nil?
      redirect_to admin_posts_url, :notice => t('messages.posts.could_not_find')
    end
  end

  def update
    @post = Post.where(:slug => params[:id]).first

    unless current_user.sysadmin? || current_user.admin? || @post.user.nil?
      @post.user = current_user
    end

    if @post.nil?
      redirect_to admin_posts_url, :notice => t('messages.posts.could_not_find') and return
    end

    if @post.update_attributes(params[:post])
      redirect_to edit_admin_post_url(@post), :notice => t('messages.posts.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.where(:slug => params[:id]).first

    if @post.nil?
      redirect_to admin_posts_url, :notice => t('messages.posts.could_not_find') and return
    end

    @post.destroy

    redirect_to admin_posts_url, :notice => t('messages.posts.deleted')
  end
end
