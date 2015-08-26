class Admin::AccountsController < Admin::AdminController
  before_action :set_account, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @account.update(account_params)
      sign_in(@account, bypass: true)

      flash[:success] = 'Your account was successfully updated.'

      redirect_to admin_account_path
    else
      flash[:error] = @account.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  private

  def set_account
    @account = current_user
  end

  def account_params
    params.required(:account).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
