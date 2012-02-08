require "hierarchy"

class Admin::PagesController < Admin::AdminController
  helper_method :sort_column, :sort_order

  def index
    @pages = Page.search(params[:search]).page(params[:page]).order(sort_column + " " + sort_order)
  end

  def show
    @page = Page.find_by_slug(params[:id])

    if @page.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find"

      redirect_to admin_pages_url and return
    end
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])

    unless @page.nil?
      if @page.save
        flash[:type] = "success"

        flash[:notice] = t "flash.page.success.created", :page_title => @page.title, :undo_link => undo_link

        redirect_to admin_pages_url and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@page)

        render :action => :new and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_create"

      redirect_to new_admin_page_url and return
    end
  end

  def edit
    @page = Page.find_by_slug(params[:id])

    if @page.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find"

      redirect_to admin_pages_url and return
    end
  end

  def update
    @page = Page.find_by_slug(params[:id])

    unless @page.nil?
      if @page.update_attributes(params[:page])
        flash[:type] = "success"

        flash[:notice] = t "flash.page.success.updated", :page_title => @page.title, :undo_link => undo_link

        redirect_to admin_page_url(@page) and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@page)

        render :action => :edit and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find"

      redirect_to admin_pages_url and return
    end
  end

  def destroy
    @page = Page.find_by_slug(params[:id])

    unless @page.nil?
      Page.destroy(@page)

      flash[:type] = "success"

      flash[:notice] = t "flash.page.success.destroyed", :page_title => @page.title, :undo_link => undo_link

      redirect_to admin_pages_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find"

      redirect_to admin_pages_url and return
    end
  end

  def edit_multiple
    if params[:pages_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find_multiple"

      redirect_to admin_pages_url and return
    end

    @pages = Page.find_all_by_id(params[:pages_ids])

    if @pages.nil?
      flash[:type] = "error"

      flash[:notice] = "flash.page.error.could_not_find_multiple"

      redirect_to admin_pages_url and return
    end
  end

  def update_multiple
    if params[:pages_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find_multiple"

      redirect_to admin_pages_url and return
    end

    @page = Page.find_all_by_id(params[:pages_ids])

    unless @page.nil?
      flash[:type] = "success"

      flash[:notice] = ""

      @pages.each do |page|
        if page.update_attributes(params[:page].reject { |k, v| v.blank? })
          unless flash[:notice].blank?
            flash[:notice] += "<br />"
          end

          flash[:notice] += t "flash.page.success.updated", :page_title => page.title, :undo_link => ""
        else
          flash[:type] = "error"

          unless flash[:notice].blank?
            flash[:notice] += "<br />"
          end

          flash[:notice] += t "flash.page.error.could_not_update_multiple", :page_title => page.title

          flash[:notice] += validation_errors_for(page)
        end
      end

      redirect_to admin_pages_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find_multiple"

      redirect_to admin_pagess_url and return
    end
  end

  def destroy_multiple
    if params[:pages_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find_multiple"

      redirect_to admin_pages_url and return
    end

    @pages = Page.find_all_by_id(params[:pages_ids])

    unless @pages.nil?
      flash[:type] = "success"

      @pages.each do |page|
        Page.destroy(page)

        unless flash[:notice].blank?
          flash[:notice] += "<br />"
        end

        flash[:notice] += t "flash.page.success.destroyed", :page_title => page.title, :undo_link => ""
      end

      redirect_to admin_pages_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.page.error.could_not_find_multiple"

      redirect_to admin_pages_url and return
    end
  end

  private

  def sort_column
    Page.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_order
    ["asc", "desc"].include?(params[:order]) ? params[:order] : "asc"
  end

  def undo_link
    view_context.link_to(t("flash.versions.undo"), revert_version_path(@page.versions.scoped.last), :method => :post)
  end
end
