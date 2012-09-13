class PagesController < ApplicationController
  def show
    @page = Page.where(:slug => params[:id]).first

    if @page.nil?
      flash[:type] = "error"

      flash[:notice] = t('messages.pages.could_not_find')

      redirect_to root_url and return
    end

    @page_title = "#{@page.title} - #{t('application.title')}"
    @page_description = @page.meta_description
  end
end
