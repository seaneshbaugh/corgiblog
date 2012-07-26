require 'spec_helper'
require 'paperclip/matchers'
require 'paperclip/attachment'

RSpec.configure do |config|
  config.include Paperclip::Shoulda::Matchers
end

describe Picture do
  before do
    @picture = create(:picture)
  end

  it 'should have a valid factory' do
    @picture.should be_valid
  end

  it 'should not allow duplicate images to be uploaded' do
    second_picture = build(:picture)

    @picture.should be_valid

    second_picture.should_not be_valid
  end

  it 'should allow different images to be uploaded' do
    second_picture = create(:picture, :image => fixture_file_upload('spec/fixtures/pictures/test02.jpg', 'image/jpeg'))

    @picture.should be_valid

    second_picture.should be_valid
  end

  it 'should not allow non-images to be uploaded' do
    second_picture = build(:picture, :image => fixture_file_upload('spec/fixtures/pictures/test01.txt', 'text/plain'))

    second_picture.should_not be_valid
  end
end
