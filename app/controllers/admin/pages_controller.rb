module Admin
  class PagesController < AdminController
    before_action :set_page, only: [:show, :edit, :update, :destroy]

    authorize_resource

    def index
      @search = Page.search(params[:q])

      @pages = @search.result.page(params[:page]).per(25).by_order

      @deleted_pages = PaperTrail::Version.destroys.where(item_type: 'Page').reorder('versions.created_at DESC')
    end

    def show
      @previous_versions = @page.versions.updates.reorder('versions.created_at DESC')
    end

    def new
      @page = Page.new
    end

    def edit
    end

    def create
      @page = Page.new(page_params)

      if @page.save
        flash[:success] = t('admin.pages.messages.created')

        redirect_to admin_page_url(@page)
      else
        flash.now[:error] = view_context.error_messages_for(@page)

        render 'new'
      end
    end

    def update
      if @page.update(page_params)
        flash[:success] = t('admin.pages.messages.updated')

        redirect_to edit_admin_page_url(@page)
      else
        flash.now[:error] = view_context.error_messages_for(@page)

        render 'edit'
      end
    end

    def destroy
      @page.destroy

      flash[:success] = t('admin.pages.messages.deleted')

      redirect_to admin_pages_url
    end

    private

    def set_page
      @page = Page.where(slug: params[:id]).first

      raise ActiveRecord::RecordNotFound if @page.nil?
    end

    def page_params
      params.require(:page).permit(:title, :body, :style, :meta_description, :meta_keywords, :order, :color, :show_in_menu, :visible)
    end
  end
end
