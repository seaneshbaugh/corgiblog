module Admin
  class PicturesController < AdminController
    authorize_resource

    before_action :set_picture, only: [:show, :edit, :update, :destroy]

    def index
      @search = Picture.search(params[:q])

      @pictures = @search.result.page(params[:page]).per(25).reverse_chronological
    end

    def show
    end

    def new
      @picture = Picture.new
    end

    def edit
    end

    def create
      respond_to do |format|
        format.html do
          @picture = Picture.new(picture_params)

          if @picture.save
            flash[:success] = 'Picture was successfully created.'

            redirect_to admin_picture_url(@picture)
          else
            flash.now[:error] = view_context.error_messages_for(@picture)

            render 'new'
          end
        end

        format.js do
          @picture = Picture.create(picture_params)
        end
      end
    end

    def update
      if @picture.update(picture_params)
        flash[:success] = 'Picture was successfully updated.'

        redirect_to edit_admin_picture_url(@picture)
      else
        flash.now[:error] = view_context.error_messages_for(@picture)

        render 'edit'
      end
    end

    def destroy
      @picture.destroy

      flash[:success] = 'Picture was successfully deleted.'

      redirect_to admin_pictures_url
    end

    def selector
      @pictures = Picture.reverse_chronological

      render layout: false
    end

    private

    def set_picture
      @picture = Picture.where(id: params[:id]).first

      fail ActiveRecord::RecordNotFound if @picture.nil?
    end

    def picture_params
      params.require(:picture).permit(:title, :alt_text, :caption, :image)
    end
  end
end
