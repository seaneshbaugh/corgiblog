# frozen_string_literal: true

module Admin
  class AccountsController < AdminController
    before_action :set_account, only: %i[show edit update]

    def show; end

    def edit; end

    def update
      if @account.update(account_params)
        bypass_sign_in(@account)

        flash[:success] = 'Your account was successfully updated.'

        redirect_to admin_account_path, status: :see_other
      else
        flash.now[:error] = helpers.error_messages_for(@account)

        render 'edit', status: :unprocessable_entity
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
end
