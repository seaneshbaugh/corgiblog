# frozen_string_literal: true

class PagesController < ApplicationController
  def show
    @page = Page.friendly.find(params[:id])

    raise ActiveRecord::RecordNotFound if @page.nil?
  end
end
