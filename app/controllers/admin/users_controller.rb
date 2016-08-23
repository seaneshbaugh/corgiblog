module Admin
  class UsersController < AdminController
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    authorize_resource

    def index
      @search = User.search(params[:q])

      @users = @search.result.page(params[:page]).per(25).alphabetical

      @deleted_users = PaperTrail::Version.destroys.where(item_type: 'User').reorder('versions.created_at DESC')
    end

    def show
      @previous_versions = @user.versions.updates.reorder('versions.created_at DESC')
    end

    def new
      @user = User.new
    end

    def edit
    end

    def create
      @user = User.new(user_params)

      if @user.save
        flash[:success] = t('admin.users.messages.created')

        redirect_to admin_user_url(@user)
      else
        flash.now[:error] = view_context.error_messages_for(@user)

        render 'new'
      end
    end

    def update
      if @user.update(user_params)
        flash[:success] = t('admin.users.messages.updated')

        redirect_to edit_admin_user_url(@user)
      else
        flash.now[:error] = view_context.error_messages_for(@user)

        render 'edit'
      end
    end

    def destroy
      @user.destroy

      flash[:success] = t('admin.users.messages.deleted')

      redirect_to admin_users_url
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
