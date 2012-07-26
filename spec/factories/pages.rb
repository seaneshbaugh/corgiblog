FactoryGirl.define do
  factory :page do
    sequence(:title) { |n| "Page#{n}" }
    body SecureRandom.hex(64)
    style SecureRandom.hex(64)
    meta_description SecureRandom.hex(64)
    meta_keywords SecureRandom.hex(64)
    display_order 0
    status 0
    private false
  end
end
