# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TeamLeavesPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a visitor" do
    let(:user) { build(:employee) }

    it { should(forbid_actions([:index, :show])) }
    it { should(forbid_actions([:edit, :update])) }
  end

  context "when being a user" do
    let(:user) { create(:manager) }

    it { should(permit_actions([:index, :show])) }
    it { should(permit_actions([:edit, :update])) }
  end
end
