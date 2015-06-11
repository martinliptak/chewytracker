ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'capybara/rails'
require "minitest/rails/capybara"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Specs
  extend MiniTest::Spec::DSL

  register_spec_type self do |desc|
    desc < ActiveRecord::Base if desc.is_a? Class
  end

  # Cleaning
  before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end    
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

Capybara.current_driver = :rack_test
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :webkit

DatabaseCleaner.clean_with :truncation
