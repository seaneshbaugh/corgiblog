require 'simplecov'

Dir[Rails.root.join('test', 'support', '**', '*.rb')].each { |file| require file }

SimpleCov.start 'rails' do
  add_group 'Presenters', 'app/presenters'
  add_group 'Services', 'app/services'
  add_group 'Validators', 'app/validators'
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

Minitest::Reporters.use!

DatabaseCleaner.strategy = :transaction

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
end

module ActiveSupport
  class TestCase
    include ActionDispatch::TestProcess
    include TumblrTestHelper

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    setup do
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end
  end
end

module ActionController
  class TestCase
    include Devise::Test::ControllerHelpers
  end
end
