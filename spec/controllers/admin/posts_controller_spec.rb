require 'spec_helper'

describe Admin::PostsController do
  include Devise::TestHelpers

  Ability::ROLES.keys.each do |role|
    context "as a/an #{role} user " do
      before :each do
        @user = create "#{role.to_s}_user".to_sym

        @ability = Ability.new @user

        sign_in @user
      end

      context '#index' do
        it 'should be accessible if permission has been granted' do
          #if @ability.can?(:read, :admin_panel)
            get :index

            if @ability.can?(:read, Post, @user)
              response.status.should eq(200)

              response.should render_template('index')
            else
              response.status.should eq(302)

              response.should redirect_to(root_url)
            end
          #end
        end
      end
    end
  end
end