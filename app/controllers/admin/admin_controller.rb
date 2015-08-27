module Admin
  class AdminController < ApplicationController
    before_action :authenticate_user!

    layout 'admin'

    def index
    end
  end
end
