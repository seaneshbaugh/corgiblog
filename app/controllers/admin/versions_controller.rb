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

#      object.save

      redirect_to send("admin_#{object.class.to_s.downcase.underscore.pluralize}_path")
    end

    def destroy

    end

    private

    def set_version
      @version = PaperTrail::Version.where(id: params[:id]).first

      fail ActiveRecord::RecordNotFound if @version.nil?
    end
  end
end
