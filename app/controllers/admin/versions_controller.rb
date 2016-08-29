module Admin
  class VersionsController < AdminController
    before_action :set_version, only: [:show, :revert, :destroy]

    authorize_resource class: PaperTrail::Version

    def index
      @search = PaperTrail::Version.search(params[:q])

      @versions = @search.result.page(params[:page]).per(25).reorder('versions.created_at DESC')
    end

    def show
    end

    def revert
      object = @version.reify

      object.save

      flash[:success] = t('.admin.versions.messages.reverted', item_type: object.class.name)

      redirect_to send("admin_#{object.class.name.downcase.underscore.pluralize}_path")
    end

    def destroy
      @version.destroy

      flash[:success] = t('.admin.versions.messages.deleted', item_type: object.class.name)

      redirect_to admin_versions_url
    end

    private

    def set_version
      @version = PaperTrail::Version.where(id: params[:id]).first

      raise ActiveRecord::RecordNotFound if @version.nil?
    end
  end
end
