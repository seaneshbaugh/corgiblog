require 'rails/application/route_inspector'

class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!

  layout 'admin'

  def index
    @post = Post.new
  end

  def reboot
    %x[touch "#{File.join(Rails.root, 'tmp', 'restart.txt')}"]

    flash[:type] = 'information'

    flash[:notice] = t('reboot')

    redirect_to admin_root_url and return
  end

  def export
    #TODO: Export DB tables as SQL, YML, or CSV.

    redirect_to admin_root_url and return
  end
end
