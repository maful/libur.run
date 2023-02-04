# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("noreply@libur.run", "Libur.run Notifications")
  layout "mailer"
end
