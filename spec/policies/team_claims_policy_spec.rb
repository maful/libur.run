# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TeamClaimsPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:company) { DataVariables.company }
  let(:object) { nil }

  context "when being a user" do
    let(:user) { create(:employee) }

    it { should(forbid_actions([:index, :show])) }
    it { should(forbid_actions([:edit, :update])) }
  end

  context "when being a finance approver" do
    let(:user) { create(:employee) }

    before do
      company.update(finance_approver: user)
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
