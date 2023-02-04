# frozen_string_literal: true

require "rails_helper"

RSpec.describe(OnboardingStepComponent, type: :component) do
  it "renders onboarding feature" do
    result = render_inline(described_class.new(active: 1))

    expect(result.css("h3").to_html).to(include(OnboardingStepComponent::STEPS[0]))
  end
end
