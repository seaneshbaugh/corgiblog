require 'rails/application/route_inspector'

class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!

  layout 'admin'

  def index
    @post = Post.new
  end

  def reboot
    %x[touch "#{File.join(Rails.root, 'tmp', 'restart.txt')}"]

    redirect_to admin_root_url, :notice => t('reboot')
  end

  def export
    #TODO: Export DB tables as SQL, YML, or CSV.

    redirect_to admin_root_url, :notice => t('messages.admin.not_implemented')
  end

  def analytics
    #TODO: Google Analytics dashboard.

    redirect_to admin_root_url, :notice => t('messages.admin.not_implemented')
  end
end
