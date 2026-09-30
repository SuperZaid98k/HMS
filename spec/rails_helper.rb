# spec/rails_helper.rb
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara-playwright-driver'

# 1. Integrate Shoulda Matchers with RSpec & Rails
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# 2. Register Capybara Playwright Drivers BEFORE RSpec configuration
# Standard Headless Driver (Fast default)
Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(
    app,
    browser_type: :chromium,
    headless: true,
    playwright_cli_executable_path: "npx playwright"
  )
end

# Visible Headed Driver (Opens actual Google Chrome window with slow-mo delays)
Capybara.register_driver :headed_playwright do |app|
  Capybara::Playwright::Driver.new(
    app,
    browser_type: :chromium,
    channel: :chrome,      # Opens installed Google Chrome on Windows
    headless: false,       # Opens visible GUI window
    slow_mo: 600,          # 600ms delay between actions so you can watch
    playwright_cli_executable_path: "npx playwright"
  )
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :playwright

# 3. Single Unified RSpec Configuration Block
RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Shorthand FactoryBot methods (create(:user) instead of FactoryBot.create(:user))
  config.include FactoryBot::Syntax::Methods

  # Devise authentication helpers for requests and system specs
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system

  # ActiveJob test helpers (for verifying Sidekiq / deliver_later queues)
  config.include ActiveJob::TestHelper

  # Keep jobs in memory for all unit and controller tests
  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  # System Specs: Select visible driver if HEADED is present
  config.before(:each, type: :system) do
    system_driver = ENV['HEADED'].present? ? :headed_playwright : :playwright
    driven_by system_driver

    ActiveJob::Base.queue_adapter = :test
  end

  config.after(:each) do
    clear_enqueued_jobs
  end
end