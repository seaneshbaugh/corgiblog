class PicturesController < ApplicationController
  def index
    @search = Picture.search(params[:q])

    @pictures = @search.result.page(params[:page]).per(30).reverse_chronological

    respond_to do |format|
      format.html

      format.json do
        render json: @pictures.to_json(only: [:title, :alt_text, :caption, :image_file_name, :image_original_width, :image_original_height], image_url: [:medium, :original], scaled_width: 190)
      end
    end
  end

  def show
    @picture = Picture.where(id: params[:id]).first

    raise ActiveRecord::RecordNotFound if @picture.nil?
  end
end
