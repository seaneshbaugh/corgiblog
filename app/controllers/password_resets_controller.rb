class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email_address(params[:email_address])

    user.send_password_reset if user
      flash[:type] = "success"

      flash[:notice] = t "flash.session.password_resets.sent_email"

      redirect_to root_url and return
  end

  def edit
    @user = User.find_by_password_reset_token(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token(params[:id])

    if @user.password_reset_sent_at < 2.hours.ago
      flash[:type] = "success"

      flash[:notice] = t "flash.session.password_resets.expired"

      redirect_to new_password_reset_path and return
    else
      if @user.update_attributes(params[:user])
        flash[:type] = "success"

        flash[:notice] = t "flash.session.password_resets.reset"

        redirect_to root_url and return
      else
        flash.now[:notice] = @user.errors

        render :edit and return
      end
    end
  end
end
