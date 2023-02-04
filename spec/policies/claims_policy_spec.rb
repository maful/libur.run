# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ClaimsPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a visitor" do
    let(:account) { build(:account) }
    let(:user) { build(:employee, account:) }

    it { should(forbid_actions([:index, :show, :new])) }
    it { should(forbid_actions([:create, :cancel, :validate_claim])) }
  end

  context "when being a user" do
    let(:account) { create(:account, with_employee: true) }
    let(:user) { account.employee }

    it { should(permit_actions([:index, :show, :new])) }
    it { should(permit_actions([:create, :cancel, :validate_claim])) }
  end
end
