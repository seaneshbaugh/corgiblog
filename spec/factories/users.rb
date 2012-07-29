FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@conneythecorgi.com"
  end

  sequence :first_name do |n|
    "First #{n}"
  end

  sequence :last_name do |n|
    "Last #{n}"
  end

  factory :user do
    email
    first_name
    last_name
    password 'test123'
    password_confirmation 'test123'
    role Ability::ROLES[:read_only]

    trait :read_only do
      role Ability::ROLES[:read_only]
    end

    trait :contributor do
      role Ability::ROLES[:contributor]
    end

    trait :admin do
      role Ability::ROLES[:admin]
    end

    trait :sysadmin do
      role Ability::ROLES[:sysadmin]
    end

    factory :read_only_user, :traits => [:read_only]
    factory :contributor_user, :traits => [:contributor]
    factory :admin_user, :traits => [:admin]
    factory :sysadmin_user, :traits => [:sysadmin]
  end
end
