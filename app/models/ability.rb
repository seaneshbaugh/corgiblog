class Ability
  include CanCan::Ability

  ROLES = {
    :read_only => 'read_only',
    :contributor => 'contributor',
    :admin => 'admin',
    :sysadmin => 'sysadmin'
  }

  def initialize(user)
    user ||= User.new

    cannot :manage, :all

    case user.role
      when ROLES[:sysadmin] then
        can :manage, :all
      when ROLES[:admin] then
        can :manage, :all
        cannot [:create, :update, :destroy], User do |u|
          user.role == ROLES[:sysadmin]
        end
      when ROLES[:contributor] then
        can [:read, :update], Post
        can :read, :admin_panel
      when ROLES[:read_only] then
        can :read, Post
        can :read, :admin_panel
      else
        cannot :read, all
    end
  end


  #def initialize(user)
  #  user ||= User.new
  #
  #  @user = user
  #
  #  # cancan default aliased actions that already exist
  #  #    :read => [:index, :show]
  #  #    :create => [:new]
  #  #    :update => [:edit]
  #
  #  alias_action :index, :show, :edit, :update, :destroy, :to => :touch
  #  alias_action :edit, :update, :to => :modify
  #
  #  if @user.sysadmin?
  #    setup_sysadmin_permissions!
  #  else
  #    setup_default_permissions!
  #
  #    if @user.admin?
  #      setup_admin_permissions!
  #    elsif @user.contributor?
  #      setup_contributor_permissions!
  #    else
  #      setup_read_only_permissions!
  #    end
  #  end
  #end
  #
  #def setup_default_permissions!
  #  cannot :manage, :all
  #end
  #
  #def setup_sysadmin_permissions!
  #  can :manage, :all
  #  can :read, :admin_panel
  #  can :reboot, :application
  #  can :export, :database
  #end
  #
  #def setup_admin_permissions!
  #  can [:read, :create, :touch, :destroy], Page
  #  can [:read, :create, :touch, :destroy], Picture
  #  can [:read, :create, :touch, :destroy], Post
  #  can [:read, :create, :touch, :destroy], User
  #  can :read, :admin_panel
  #end
  #
  #def setup_contributor_permissions!
  #  can [:read], Page
  #  can [:read], Picture
  #  can [:read, :touch], Post
  #  can :read, :admin_panel
  #end
  #
  #def setup_read_only_permissions!
  #  cannot :read, :admin_panel
  #end
end