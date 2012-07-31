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

  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to admin_pages_url, :notice => t('messages.pages.created')
    else
      render 'new'
    end
  end

  def edit
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      redirect_to admin_pages_url, :notice => t('messages.pages.could_not_find')
    end
  end

  def update
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      redirect_to admin_pages_url, :notice => t('messages.pages.could_not_find') and return
    end

    if @page.update_attributes(params[:page])
      redirect_to edit_admin_page_url(@page), :notice => t('messages.pages.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      redirect_to admin_pages_url, :notice => t('messages.pages.could_not_find') and return
    end

    @page.destroy

    redirect_to admin_pages_url, :notice => t('messages.pages.deleted')
  end
end
