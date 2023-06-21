# frozen_string_literal: true

require "capybara/cuprite"

# NOTE: The name :cuprite is already registered by Rails.
# See https://github.com/rubycdp/cuprite/issues/180
# rubocop:disable Style/RedundantDoubleSplatHashBraces
Capybara.register_driver(:liburrun_cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    **{
      window_size: [1200, 800],
      # See additional options for Dockerized environment in the respective section of this article
      browser_options: {},
      # Increase Chrome startup wait time (required for stable CI builds)
      process_timeout: 10,
      # Enable debugging capabilities
      inspector: true,
      # Allow running Chrome in a headful mode by setting HEADLESS env
      # var to a falsey value
      headless: !ENV["HEADLESS"].in?(["n", "0", "no", "false"]),
    },
  )
end
# rubocop:enable Style/RedundantDoubleSplatHashBraces

Capybara.default_driver = Capybara.javascript_driver = :liburrun_cuprite
Capybara.default_max_wait_time = 2

# Normalize whitespaces when using `has_text?` and similar matchers,
# i.e., ignore newlines, trailing spaces, etc.
# That makes tests less dependent on slightly UI changes.
Capybara.default_normalize_ws = true

# Where to store system tests artifacts (e.g. screenshots, downloaded files, etc.).
# It could be useful to be able to configure this path from the outside (e.g., on CI).
Capybara.save_path = ENV.fetch("CAPYBARA_ARTIFACTS", "./tmp/capybara")
