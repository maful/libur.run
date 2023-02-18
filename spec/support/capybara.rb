Webdrivers::Chromedriver.required_version = "110.0.5481.77"

Capybara.register_driver :selenium_chrome_headless_custom_browser do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.binary = "/Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser"
  browser_options.args << "--headless"
  browser_options.args << "--disable-gpu"
  # Sandbox cannot be used inside unprivileged Docker container
  browser_options.args << "--no-sandbox"
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

default_js_driver = :selenium_chrome_headless_custom_browser

Capybara.default_driver = default_js_driver
Capybara.javascript_driver = default_js_driver
Capybara.default_max_wait_time = 2

RSpec.configure do |config|
  config.before(:each) do |example|
    Capybara.current_driver = default_js_driver if example.metadata[:js]
    Capybara.current_driver = :selenium_chrome if example.metadata[:selenium_chrome]
  end

  config.after(:each) do
    Capybara.use_default_driver
  end
end

