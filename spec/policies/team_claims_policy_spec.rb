# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TeamClaimsPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a user" do
    let(:user) { create(:employee) }

    it { should(forbid_actions([:index, :show])) }
    it { should(forbid_actions([:edit, :update])) }
  end

  context "when being a finance approver" do
    let(:user) { create(:employee) }

    before do
      user
      DataVariables.company.update(finance_approver_id: user.id)
    end

    after do
      DataVariables.company.update(finance_approver_id: nil)
    end

    it { should(permit_actions([:index, :show])) }
    it { should(permit_actions([:edit, :update])) }
  end

  context "when being an admin company" do
    let(:user) { create(:admin) }

    it { should(permit_actions([:index, :show])) }
    it { should(forbid_actions([:edit, :update])) }
  end
end
