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
        can :read, :rails_info
        can :export, :database
        can :read, :analytics
        can :reboot, :application
      when ROLES[:admin] then
        can :manage, :all
        #TODO: Figure this out!
        #cannot [:create, :update, :destroy], User do |u|
        #  user.role == ROLES[:sysadmin]
        #end
        cannot :reboot, :application
        cannot :read, :rails_info
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
end