require 'rubygems'
require 'capybara/rspec'
require 'spork'
require 'views/inherited_resource_helpers'
require 'controllers/support/controller_specs_helpers'
require 'paperclip/matchers'

ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Spork.trap_method Jujutsu
  # Devise preloads the User model. Avoid this by delaying route loading.
  require "rails/application"
  Spork.trap_method(Rails::Application, :reload_routes!)
end

Spork.each_run do
  PanterControlling::Application.reload_routes!
end

Spork.each_run do
  FactoryGirl.factories.clear
  load 'spec/factories.rb'
end

RSpec.configure do |config|
  # == Mock Framework
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.use_transactional_examples = false


  # DatabaseCleaner is needed, because use_transactional_fixtures is off. It is
  # off to be able to use Selenium as capybara driver.
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Include Paperclip matchers
  config.include Paperclip::Shoulda::Matchers
end
