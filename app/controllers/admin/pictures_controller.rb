class Admin::PicturesController < Admin::AdminController
  helper_method :sort_column, :sort_order

  def index
    @pictures = Picture.search(params[:search]).page(params[:page]).order(sort_column + " " + sort_order)
  end

  def show
    @picture = Picture.find_by_id(params[:id])

    if @picture.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.picture.error.could_not_find"

      redirect_to admin_pictures_url and return
    end
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(params[:picture])

    if params[:picture] and params[:picture][:image].blank?
      flash[:type] = "error"

      flash[:notice] = t "flash.picture.error.no_image_selected"

      render :action => :new and return
    end

    flash[:type] = "success"

    flash[:notice] = ""

    params[:picture][:image].length.times do |i|
      picture = Picture.new

      picture.title = params[:picture][:title]

      picture.alt_text = params[:picture][:alt_text]

      picture.caption = params[:picture][:caption]

      picture.image = params[:picture][:image][i]

      if picture.save
        flash[:notice] << t("flash.picture.success.created", :picture_title => picture.title) # , :undo_link => "" #undo_link
      else
        flash[:type] = "error"

        flash[:notice] << validation_errors_for(picture)
      end
    end

    if flash[:type] == "error"
      render :action => :new and return
    else
      redirect_to admin_pictures_url and return
    end
  end

  def edit
    @picture = Picture.find_by_id(params[:id])

    if @picture.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.picture.error.could_not_find"

      redirect_to admin_pictures_url and return
    end
  end

  def update
    @picture = Picture.find_by_id(params[:id])

    unless @picture.nil?
      if @picture.update_attributes(params[:picture])
        flash[:type] = "success"

        flash[:notice] = t "flash.picture.success.updated", :picture_title => @picture.title

        redirect_to admin_picture_url(@picture) and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@picture)

        render :action => :edit and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.picture.error.could_not_find"

      redirect_to admin_pictures_url and return
    end
  end

  def destroy
    @picture = Picture.find_by_id(params[:id])

    unless @picture.nil?
      Picture.destroy(@picture)

      flash[:type] = "success"

      flash[:notice] = t "flash.picture.success.destroyed", :picture_title => @picture.title

      redirect_to admin_pictures_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.picture.error.could_not_find"

      redirect_to admin_pictures_url and return
    end
  end

  def selector
    @pictures = Picture.all

    render :layout => false
  end

  private

  def sort_column
    Picture.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_order
    ["asc", "desc"].include?(params[:order]) ? params[:order] : "asc"
  end

  #def undo_link
    #view_context.link_to(t("flash.versions.undo"), revert_version_path(@picture.versions.scoped.last), :method => :post)
  #end
end
