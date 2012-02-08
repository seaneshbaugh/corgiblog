class SessionsController < ApplicationController
  before_filter :ensure_login, :only => :destroy
  before_filter :ensure_logout, :only => [:new, :create]

  def new
  end

  def create
    user = User.authenticate(params[:email_address], params[:password], params[:limit_session])

    if user
      if params[:remember_me]
        cookies.permanent[:remember_me_token] = user.remember_me_token
      else
         cookies[:remember_me_token] = user.remember_me_token
      end

      flash[:type] = "success"

      flash[:notice] = t "flash.session.success.login", :user_name => user.first_name

      redirect_to root_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.session.error.login"

      redirect_to root_url and return
    end
  end

  def destroy
    cookies.delete(:remember_me_token)

    redirect_to root_url and return
  end
end
