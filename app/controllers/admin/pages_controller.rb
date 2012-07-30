class Admin::PagesController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = Page.unscoped.search(params[:q])
    else
      @search = Page.search(params[:q])
    end

    @pages = @search.result.page(params[:page])
  end

  def show
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      redirect_to admin_pages_url, :notice => t('messages.pages.could_not_find')
    end
  end

  def new
    @page = Page.new
  end

  def edit
    @page = Post.where(:slug => params[:id]).first

    if @page.nil?
      redirect_to admin_pages_url, :notice => t('messages.pages.could_not_find')
    end
  end

  def update
    @page = Post.where(:slug => params[:id]).first

    if @page.nil?
      redirect_to admin_pages_url, :notice => t('messages.pages.could_not_find') and return
    end

    if @page.update_attributes(params[:page])
      redirect_to admin_edit_page_url(@page), :notice => t('messages.pages.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @page = Post.where(:slug => params[:id]).first

    if @page.nil?
      redirect_to admin_pages_url, :notice => t('messages.pages.could_not_find') and return
    end

    @page.destroy

    redirect_to admin_pages_url, :notice => t('messages.pages.deleted')
  end
end
