require 'spec_helper'

describe Page do
  before do
    @page = create(:page)
  end

  it 'should have a valid factory' do
    @page.should be_valid
  end
end
