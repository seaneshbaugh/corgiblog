class Admin::PicturesController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = Picture.unscoped.search(params[:q])
    else
      @search = Picture.search(params[:q])
    end

    @pictures = @search.result.page(params[:page])
  end

  def show
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      redirect_to admin_pictures_url, :notice => t('messages.pictures.could_not_find')
    end
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(params[:picture])

    if @picture.save
      redirect_to admin_pictures_url, :notice => t('messages.pictures.created')
    else
      render 'new'
    end
  end

  def edit
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      redirect_to admin_pictures_url, :notice => t('messages.pictures.could_not_find')
    end
  end

  def update
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      redirect_to admin_pictures_url, :notice => t('messages.pictures.could_not_find') and return
    end

    if @picture.update_attributes(params[:picture])
      redirect_to admin_edit_picture_url(@picture), :notice => t('messages.pictures.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      redirect_to admin_pictures_url, :notice => t('messages.pictures.could_not_find') and return
    end

    @picture.destroy

    redirect_to admin_pictures_url, :notice => t('messages.pictures.deleted')
  end
end
