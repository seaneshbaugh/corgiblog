require 'spec_helper'

describe Post do
  before do
    @post = create(:post)
  end

  it 'should have a valid factory' do
    @post.should be_valid
  end
end
