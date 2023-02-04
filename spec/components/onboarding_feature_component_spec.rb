# frozen_string_literal: true

require "rails_helper"

RSpec.describe(OnboardingFeatureComponent, type: :component) do
  it "renders onboarding feature" do
    result = render_inline(described_class.new(active: 1))

    expect(result.at_css("h1").to_html).to(include(OnboardingFeatureComponent::FEATURES[0][1]))
    expect(result.at_css("p").to_html).to(include(OnboardingFeatureComponent::FEATURES[0][2]))
  end
end
