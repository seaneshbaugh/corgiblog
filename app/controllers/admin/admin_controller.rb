class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!

  layout 'admin'

  helper :all

  def index
    @post = Post.new
  end

  def reboot
    %x[touch "#{File.join(Rails.root, 'tmp', 'restart.txt')}"]

    flash[:type] = 'information'

    flash[:notice] = t 'flash.reboot'

    redirect_to admin_root_url and return
  end

  def export
  end
end
