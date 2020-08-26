# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      authorize User

      @search = User.ransack(params[:q])

      @users = @search.result.page(params[:page]).per(25).alphabetical
    end

    def show
      authorize @user
    end

    def new
      authorize User

      @user = User.new
    end

    def edit
      authorize @user
    end

    def create
      authorize User

      @user = User.new(user_params)

      if @user.save
        flash[:success] = t('.success')

        redirect_to admin_user_url(@user), status: :see_other
      else
        flash[:error] = helpers.error_messages_for(@user)

        render 'new', status: :unprocessable_entity
      end
    end

    def update
      authorize @user

      if @user.update(user_params)
        flash[:success] = t('.success')

        redirect_to edit_admin_user_url(@user), status: :see_other
      else
        flash[:error] = helpers.error_messages_for(@user)

        render 'edit', status: :unprocessable_entity
      end
    end

    def destroy
      authorize @user

      @user.destroy

      flash[:success] = t('.success')

      redirect_to admin_users_url, status: :see_other
    end

    private

    def set_user
      @user = User.where(id: params[:id]).first

      raise ActiveRecord::RecordNotFound if @user.nil?
    end

    def user_params
      params.required(:user).permit(:email, :password, :password_confirmation, :role, :first_name, :last_name)
    end
  end
end
