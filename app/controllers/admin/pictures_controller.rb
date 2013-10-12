class Admin::PicturesController < Admin::AdminController
  before_filter :authenticate_user!

  authorize_resource

  def index
    @search = Picture.search(params[:q])

    @pictures = @search.result.page(params[:page]).per(25).order('`pictures`.`created_at` DESC')
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
      format.html {
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
      }
      format.js {
        @picture = Picture.create(params[:picture])
      }
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
    @pictures = Picture.order('`pictures`.`created_at` DESC')

    render :layout => false
  end
end
