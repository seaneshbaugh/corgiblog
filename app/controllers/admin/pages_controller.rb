class Admin::PagesController < Admin::AdminController
  before_filter :authenticate_user!

  authorize_resource

  def index
    @search = Page.search(params[:q])

    @pages = @search.result.page(params[:page]).per(25).order('`pages`.`order` ASC')
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
