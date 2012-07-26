require 'spec_helper'

describe User do
  before do
    @user = create(:user)
  end

  it 'should have a valid factory' do
    @user.should be_valid
  end
end
