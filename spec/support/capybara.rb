# Capybara.javascript_driver = :selenium_chrome

require "selenium/webdriver"

Capybara.register_driver :selenium_chrome_in_container do |app|
  Capybara::Selenium::Driver.new app,
                                 browser: :remote,
                                 url: "http://selenium_chrome:4444/wd/hub",
                                 desired_capabilities: :chrome
end

Capybara.register_driver :headless_selenium_chrome_in_container do |app|
  Capybara::Selenium::Driver.new app,
                                 browser: :remote,
                                 url: "http://selenium_chrome:4444/wd/hub",
                                 desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
                                   chromeOptions: { org: %w[headless disable-gpu] }
                                 )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  ## for MacOS
  # config.before(:each, type: :system, js: true) do
  #   driven_by :selenium_chrome_headless
  # end

  ## for Docker
  config.before(:each, type: :system, js: true) do
    # driven_by :selenium_chrome_in_container
    driven_by :headless_selenium_chrome_in_container
    Capybara.server_host = "0.0.0.0"
    Capybara.server_port = 4000
    Capybara.app_host = 'http://web:4000'
  end
end
