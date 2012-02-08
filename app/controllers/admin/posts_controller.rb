class Admin::PostsController < Admin::AdminController
  helper_method :sort_column, :sort_order

  def index
    @posts = Post.search(params[:search]).page(params[:page]).order(sort_column + " " + sort_order)
  end

  def show
    @post = Post.find_by_slug(params[:id])

    if @post.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find"

      redirect_to admin_posts_url and return
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])

    unless @post.nil?
      @post.user = @current_user

      if @post.save
        flash[:type] = "success"

        flash[:notice] = t "flash.post.success.created", :post_title => @post.title, :undo_link => undo_link

        redirect_to admin_posts_url and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@post)

        render :action => :new and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_create"

      redirect_to new_admin_post_url and return
    end
  end

  def edit
    @post = Post.find_by_slug(params[:id])

    if @post.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find"

      redirect_to admin_posts_url and return
    end
  end

  def update
    @post = Post.find_by_slug(params[:id])

    unless @post.nil?
      if @post.update_attributes(params[:post])
        flash[:type] = "success"

        flash[:notice] = t "flash.post.success.updated", :post_title => @post.title, :undo_link => undo_link

        redirect_to admin_post_url(@post) and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@post)

        render :action => :edit and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find"

      redirect_to admin_posts_url and return
    end
  end

  def destroy
    @post = Post.find_by_slug(params[:id])

    unless @post.nil?
      Post.destroy(@post)

      flash[:type] = "success"

      flash[:notice] = t "flash.post.success.destroyed", :post_title => @post.title, :undo_link => undo_link

      redirect_to admin_posts_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find"

      redirect_to admin_posts_url and return
    end
  end

  def edit_multiple
    if params[:posts_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find_multiple"

      redirect_to admin_posts_url and return
    end

    @posts = Post.find_all_by_id(params[:posts_ids])

    if @posts.nil?
      flash[:type] = "error"

      flash[:notice] = "flash.post.error.could_not_find_multiple"

      redirect_to admin_posts_url and return
    end
  end

  def update_multiple
    if params[:posts_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find_multiple"

      redirect_to admin_posts_url and return
    end

    @post = Post.find_all_by_id(params[:posts_ids])

    unless @post.nil?
      flash[:type] = "success"

      flash[:notice] = ""

      @posts.each do |post|
        if Post.update_attributes(params[:post].reject { |k, v| v.blank? })
          unless flash[:notice].blank?
            flash[:notice] += "<br />"
          end

          flash[:notice] += t "flash.post.success.updated", :post_title => post.title, :undo_link => ""
        else
          flash[:type] = "error"

          unless flash[:notice].blank?
            flash[:notice] += "<br />"
          end

          flash[:notice] += t "flash.post.error.could_not_update_multiple", :post_title => post.title

          flash[:notice] += validation_errors_for(post)
        end
      end

      redirect_to admin_posts_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find_multiple"

      redirect_to admin_postss_url and return
    end
  end

  def destroy_multiple
    if params[:posts_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find_multiple"

      redirect_to admin_posts_url and return
    end

    @posts = Post.find_all_by_id(params[:posts_ids])

    unless @posts.nil?
      flash[:type] = "success"

      @posts.each do |post|
        Post.destroy(post)

        unless flash[:notice].blank?
          flash[:notice] += "<br />"
        end

        flash[:notice] += t "flash.post.success.destroyed", :post_title => post.title, :undo_link => ""
      end

      redirect_to admin_posts_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.post.error.could_not_find_multiple"

      redirect_to admin_posts_url and return
    end
  end

  private

  def sort_column
    Post.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_order
    ["asc", "desc"].include?(params[:order]) ? params[:order] : "desc"
  end

  def undo_link
    view_context.link_to(t("flash.versions.undo"), revert_version_path(@post.versions.scoped.last), :method => :post)
  end
end
