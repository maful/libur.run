# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Settings::CompanyPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a user" do
    let(:account) { create(:account, with_employee: true) }
    let(:user) { account.employee }

    it { should(forbid_actions([:show, :update])) }
  end

  context "when being an admin" do
    let(:account) { create(:account) }
    let(:user) { create(:admin, account:) }

    it { should(permit_actions([:show, :update])) }
  end
end
