include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :picture do
    sequence(:title) { |n| "Picture#{n}" }
    alt_text SecureRandom.hex(64)
    caption SecureRandom.hex(64)
    image { fixture_file_upload('spec/fixtures/pictures/test01.jpg', 'image/jpeg') }
  end
end
