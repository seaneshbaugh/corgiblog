class VersionsController < ApplicationController
  def revert
    @version = Version.find_by_id(params[:id])

    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end

    flash[:type] = "success"

    link_name = params[:redo] == "true" ? t("flash.versions.undo") : t("flash.versions.redo")

    link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), :method => :post)

    flash[:notice] = t("flash.versions.undid.#{@version.event}") + " #{link}."

    redirect_to :back and return
  end
end
