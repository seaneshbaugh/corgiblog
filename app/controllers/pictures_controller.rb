class PicturesController < ApplicationController
  def index
    if params[:q].present? && params[:q][:s].present?
      @search = Picture.unscoped.search(params[:q])
    else
      @search = Picture.search(params[:q])
    end

    @pictures = @search.result.page(params[:page]).per(100)
  end

  def show
    @picture = Picture.where(:id => params[:id]).first

    if @picture.nil?
      flash[:type] = "error"

      flash[:notice] = t('messages.pictures.could_not_find')

      redirect_to pictures_url and return
    end

    @page_title = "#{@picture.title} - #{t('application.title')}"
    @page_description = @picture.caption
  end
end
