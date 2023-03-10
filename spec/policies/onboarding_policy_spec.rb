# frozen_string_literal: true

require("rails_helper")

RSpec.describe(OnboardingPolicy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a normal user" do
    let(:user) { create(:employee) }

    it { should(forbid_actions([:index, :personal_info, :company_info])) }
    it { should(forbid_actions([:confirmation, :verified])) }
    it { should(forbid_actions([:states, :cities])) }
  end

  context "when being an admin" do
    let(:user) { create(:admin) }

    it { should(permit_actions([:index, :personal_info, :company_info])) }
    it { should(permit_actions([:confirmation, :verified])) }
    it { should(permit_actions([:states, :cities])) }
  end
end
