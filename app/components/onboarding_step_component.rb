# frozen_string_literal: true

class OnboardingStepComponent < ViewComponent::Base
  STEPS = ["Personal Info", "Company Info", "Confirmation"].freeze

  def initialize(active:)
    @active = active
    @steps = STEPS
  end
end
