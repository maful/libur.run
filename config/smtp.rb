# frozen_string_literal: true

SMTP_SETTINGS = {
  address: ENV.fetch("SMTP_ADDRESS"),
  authentication: ENV.fetch("SMTP_AUTHENTICATION", :plain),
  domain: ENV.fetch("SMTP_DOMAIN"),
  enable_starttls_auto: ENV.fetch("SMTP_ENABLE_STARTTLS", true),
  password: ENV.fetch("SMTP_PASSWORD"),
  port: ENV.fetch("SMTP_PORT", 587),
  user_name: ENV.fetch("SMTP_USERNAME"),
}
