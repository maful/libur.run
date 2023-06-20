# frozen_string_literal: true

require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1400, 1400],
    inspector: true,
    headless: !ENV["HEADLESS"].in?(["n", "0", "no", "false"]),
  )
end

Capybara.default_driver = Capybara.javascript_driver = :cuprite
Capybara.default_max_wait_time = 4
