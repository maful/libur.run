# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TeamLeavesPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a visitor" do
    let(:account) { build(:account) }
    let(:user) { build(:employee, account:) }

    it { should(forbid_actions([:index, :show])) }
    it { should(forbid_actions([:edit, :update])) }
  end

  context "when being a user" do
    let(:account) { create(:account) }
    let(:user) { create(:employee, with_manager_role: true, account:) }

    it { should(permit_actions([:index, :show])) }
    it { should(permit_actions([:edit, :update])) }
  end
end
