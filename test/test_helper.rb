ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'

# Pretty output
require "minitest/reporters"

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

# Capybara and capybara-webkit
require 'capybara/rails'
require "minitest/rails/capybara"

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :webkit
Capybara.match = :prefer_exact
Capybara.exact = true

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

# Test helpers
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

# Just in case
DatabaseCleaner.clean_with :truncation

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Specs
  extend MiniTest::Spec::DSL

  register_spec_type self do |desc|
    desc < ActiveRecord::Base if desc.is_a? Class
  end

  # Test helpers
  include SessionHelpers
end
