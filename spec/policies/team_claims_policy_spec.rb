# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TeamClaimsPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let!(:company) { create(:company) }
  let(:object) { nil }

  context "when being a user" do
    let(:account) { create(:account) }
    let(:user) { create(:employee, with_manager_role: true, account:) }

    it { should(forbid_actions([:index, :show])) }
    it { should(forbid_actions([:edit, :update])) }
  end

  context "when being a finance approver" do
    let(:account) { create(:account) }
    let(:user) { create(:employee, account:) }

    before do
      company.update(finance_approver: user)
    end

    it { should(permit_actions([:index, :show])) }
    it { should(permit_actions([:edit, :update])) }
  end

  context "when being an admin company" do
    let(:account) { create(:account) }
    let(:user) { create(:employee, with_admin_role: true, account:) }

    it { should(permit_actions([:index, :show])) }
    it { should(forbid_actions([:edit, :update])) }
  end
end
