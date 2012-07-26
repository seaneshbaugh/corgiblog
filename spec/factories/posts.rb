FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Post#{n}" }
    body SecureRandom.hex(64)
    style SecureRandom.hex(64)
    meta_description SecureRandom.hex(64)
    meta_keywords SecureRandom.hex(64)
    association :user
    status 0
    private false
  end
end
