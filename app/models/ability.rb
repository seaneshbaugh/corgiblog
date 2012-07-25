class Ability
  include CanCan::Ability

  ROLES = {
    :read_only => 'read_only',
    :contributor => 'contributor',
    :admin => 'admin',
    :sysadmin => 'sysadmin'
  }
end