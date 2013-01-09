class Admin::PagesController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = Page.unscoped.search(params[:q])
    else
      @search = Page.search(params[:q])
    end

    @pages = @search.result.page(params[:page]).order('pages.order ASC').per(25)
  end

  def show
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      flash[:error] = t('messages.pages.could_not_find')

      redirect_to admin_pages_url
    end
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      flash[:success] = t('messages.pages.created')

      if params[:redirect_to_new].present?
        redirect_to new_admin_page_url
      else
        redirect_to admin_pages_url
      end
    else
      flash[:error] = @page.errors.full_messages.uniq.join('. ') + '.'

      render 'new'
    end
  end

  def edit
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      flash[:error] = t('messages.pages.could_not_find')

      redirect_to admin_pages_url
    end
  end

  def update
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      flash[:error] = t('messages.pages.could_not_find')

      redirect_to admin_pages_url and return
    end

    if @page.update_attributes(params[:page])
      flash[:success] = t('messages.pages.updated')

      redirect_to edit_admin_page_url(@page)
    else
      flash[:error] = @page.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def destroy
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      flash[:error] = t('messages.pages.could_not_find')

      redirect_to admin_pages_url and return
    end

    @page.destroy

    flash[:success] = t('messages.pages.deleted')

    redirect_to admin_pages_url
  end
end
