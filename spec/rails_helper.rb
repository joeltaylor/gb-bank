ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

# Prevent database truncation if the environment is production
if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

require "spec_helper"
require "rspec/rails"
require "capybara/rails"
require "capybara/rspec"
require "capybara-screenshot/rspec"

require "shoulda/matchers"

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

# Require all support files
Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

DEFAULT_PASSWORD = "password".freeze

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryGirl::Syntax::Methods
  config.include FeatureHelpers, type: :feature
  config.include AbstractController::Translation, type: :feature
  config.include ViewHelpers, type: :view

  config.before(:each, js: true) do
    # Since we (sometimes) use the same driver for both JS and non-JS tests
    # we need an easy way of distinguishing when JS is actually enabled.
    @javascript_enabled = true
  end

  config.before(:each, type: :feature) do
    # resize_window_default
  end

  config.before(:each, :mobile, type: :feature) do
    # resize_window_to_mobile

    # rack-test has no concept of a window so need to use :webkit for mobile
    # responsive tests
    Capybara.current_driver = :webkit
  end
end

Capybara.configure do |config|
  config.ignore_hidden_elements = true
  config.javascript_driver = :webkit
end

Capybara::Screenshot.autosave_on_failure = false

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end
