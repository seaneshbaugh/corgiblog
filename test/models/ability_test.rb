require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test 'find the valid roles for a sysadmin user' do
    user = users(:sean_eshbaugh)

    valid_roles = { read_only: 'read_only', admin: 'admin', sysadmin: 'sysadmin' }

    assert_equal Ability.valid_roles_for(user), valid_roles
  end

  test 'find the valid roles for an admin user' do
    user = users(:casie_clark)

    valid_roles = { read_only: 'read_only', admin: 'admin' }

    assert_equal Ability.valid_roles_for(user), valid_roles
  end

  test 'find the valid roles for a read only user' do
    user = users(:conney_the_corgi)

    valid_roles = {}

    assert_equal Ability.valid_roles_for(user), valid_roles
  end
end
