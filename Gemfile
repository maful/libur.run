# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.0"
gem "hiredis", "~> 0.6.3"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem "rodauth-rails", "~> 1.7"
gem "nanoid", "~> 2.0"
gem "strong_migrations", "~> 1.3"
gem "letter_opener_web", "~> 2.0"
gem "annotate", "~> 3.2"
gem "pundit", "~> 2.3"
gem "inline_svg", "~> 1.8"
gem "view_component", "~> 2.82"
gem "city-state", "~> 0.1.0"
gem "sidekiq", "~> 6.5"
gem "simple_form", "~> 5.1"
gem "draper", "~> 4.0"
gem "turbo_ready", "~> 0.1.2"
gem "gretel", "~> 4.4"
gem "country_select", "~> 8.0"
gem "action_markdown", github: "alexandreruban/action-markdown", branch: "main"
gem "aasm", "~> 5.4"
gem "after_commit_everywhere", "~> 1.2"
gem "pagy", "~> 6.0"
gem "ransack", "~> 3.2"
gem "money-rails", "~> 1.15"
gem "activestorage-validator", "~> 0.2.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails", "~> 2.8"
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.2"
  gem "rubocop", "~> 1.38", require: false
  gem "rubocop-rails", "~> 2.17", require: false
  gem "rubocop-rspec", "~> 2.14", require: false
  gem "rubocop-capybara", "~> 2.17", require: false
  gem "rubocop-shopify", "~> 2.10", require: false
end

group :test do
  gem "faker", "~> 2.23"
  gem "shoulda-matchers", "~> 5.2"
  gem "rails-controller-testing", "~> 1.0"
  gem "pundit-matchers", "~> 1.8"
  gem "capybara", "~> 3.38"
  gem "cuprite", "~> 0.14.3"
  gem "webmock", "~> 3.18"
  gem "rack_session_access", "~> 0.2"
  gem "database_cleaner-active_record", "~> 2.1"
  gem "simplecov", "~> 0.22.0", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler", "~> 3.0", require: false
  # For memory profiling
  gem "memory_profiler"
  # For call-stack profiling flamegraphs
  gem "stackprof"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
