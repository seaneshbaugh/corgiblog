class PicturesController < ApplicationController
  def index
    @search = Picture.search(params[:q])

    @pictures = @search.result.page(params[:page]).per(100).order('created_at DESC')
  end

  def show
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      flash[:error] = t('messages.pictures.could_not_find')

      redirect_to pictures_url
    end
  end
end
