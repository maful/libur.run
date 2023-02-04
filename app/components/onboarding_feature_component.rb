# frozen_string_literal: true

class OnboardingFeatureComponent < ViewComponent::Base
  FEATURES = [
    ["notifications", "Notifications", "Real-time notifications in app or in the email"],
    ["reporting", "Reporting", "Everything you want to see, is in the report"],
    ["safe", "Privacy & Security", "Your data is safe and encrypted. Privacy & Security is our DNA"],
    ["welcome", "Welcome!", "We're happy to welcome you and your team"],
  ].freeze

  def initialize(active:)
    @feature = FEATURES[active - 1]
  end
end
