require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#ability should return an Ability for a user' do
    user = users(:sean_eshbaugh)

    ability = user.ability

    assert_equal ability.class, Ability
  end

  test '#full_name should return a users first name and last name' do
    user = users(:sean_eshbaugh)

    assert_equal 'Sean Eshbaugh', user.full_name
  end

  test '#short_name should return a users first initial and last name' do
    user = users(:sean_eshbaugh)

    assert_equal 'S. Eshbaugh', user.short_name
  end
end
