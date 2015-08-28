require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test 'find the valid roles for a sysadmin user' do
    user = users(:sean_eshbaugh)

    assert_equal Ability.valid_roles_for(user), { read_only: 'read_only', admin: 'admin', sysadmin: 'sysadmin' }
  end

  test 'find the valid roles for an admin user' do
    user = users(:casie_clark)

    assert_equal Ability.valid_roles_for(user), { read_only: 'read_only', admin: 'admin' }
  end

  test 'find the valid roles for a read only user' do
    user = users(:conney_the_corgi)

    assert_equal Ability.valid_roles_for(user), {}
  end
end
