class Admin::PicturesController < Admin::AdminController
  authorize_resource

  def index
    @search = Picture.search(params[:q])

    if params[:all]
      @pictures = @search.result.order('created_at DESC').page(1).per(Picture.count)
    else
      @pictures = @search.result.order('created_at DESC').page(params[:page])
    end
  end

  def show
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      flash[:error] = t('messages.pictures.could_not_find')

      redirect_to admin_pictures_url
    end
  end

  def new
    @picture = Picture.new
  end

  def create
    respond_to do |format|
      format.html do
        @picture = Picture.new(params[:picture])

        if @picture.save
          flash[:success] = t('messages.pictures.created')

          if params[:redirect_to_new].present?
            redirect_to new_admin_picture_url
          else
            redirect_to admin_pictures_url
          end
        else
          flash[:error] = @picture.errors.full_messages.uniq.join('. ') + '.'

          render 'new'
        end
      end

      format.js do
        @picture = Picture.create(params[:picture])
      end
    end
  end

  def edit
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      flash[:error] = t('messages.pictures.could_not_find')

      redirect_to admin_pictures_url
    end
  end

  def update
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      flash[:error] = t('messages.pictures.could_not_find')

      redirect_to admin_pictures_url and return
    end

    if @picture.update_attributes(params[:picture])
      flash[:success] = t('messages.pictures.updated')

      redirect_to edit_admin_picture_url(@picture)
    else
      flash[:error] = @picture.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def destroy
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      flash[:error] = t('messages.pictures.could_not_find')

      redirect_to admin_pictures_url and return
    end

    @picture.destroy

    flash[:success] = t('messages.pictures.deleted')

    redirect_to admin_pictures_url
  end

  def selector
    @pictures = Picture.order('created_at DESC')

    render :layout => false
  end
end
