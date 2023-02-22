# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Settings::PasswordPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a user" do
    let(:user) { create(:employee) }

    it { should(permit_actions([:show, :update])) }
  end
end
