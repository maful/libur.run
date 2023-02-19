headless_js_driver = :selenium_chrome_headless
js_driver = :selenium_chrome

Webdrivers::Chromedriver.required_version = "110.0.5481.77"

# if CUSTOM_BROWSER is defined, should be in local development
if ENV["CUSTOM_BROWSER"].present?
  Capybara.register_driver :selenium_chrome_headless_custom_browser do |app|
    Capybara::Selenium::Driver.load_selenium
    browser_options = Selenium::WebDriver::Chrome::Options.new
    browser_options.binary = ENV["CUSTOM_BROWSER"]
    browser_options.add_argument("--headless")
    browser_options.add_argument("--disable-gpu")
    # Sandbox cannot be used inside unprivileged Docker container
    browser_options.add_argument("--no-sandbox")
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    browser_options.add_argument("--disable-site-isolation-trials")
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
  end

  Capybara.register_driver :selenium_chrome_custom_browser do |app|
    Capybara::Selenium::Driver.load_selenium
    browser_options = Selenium::WebDriver::Chrome::Options.new
    browser_options.binary = ENV["CUSTOM_BROWSER"]
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    browser_options.add_argument("--disable-site-isolation-trials")
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
  end

  headless_js_driver = :selenium_chrome_headless_custom_browser
  js_driver = :selenium_chrome_custom_browser
end

# override configuration in CI
if ENV["RAILS_CI"].present?
  headless_js_driver = :selenium_chrome_headless
  js_driver = :selenium_chrome_headless
end

Capybara.default_driver = headless_js_driver
Capybara.javascript_driver = headless_js_driver
Capybara.default_max_wait_time = 2

RSpec.configure do |config|
  config.before(:each) do |example|
    Capybara.current_driver = js_driver if example.metadata[:selenium_chrome]
  end

  config.after(:each) do
    Capybara.use_default_driver
  end
end

