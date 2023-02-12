# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UsersPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a visitor" do
    let(:account) { build(:account) }
    let(:user) { build(:employee, account:) }

    it { should(forbid_action(:index)) }
  end

  context "when being a user" do
    let(:account) { create(:account, with_employee: true) }
    let(:user) { account.employee }

    it { should(forbid_action(:index)) }
  end

  context "when being an admin" do
    let(:account) { create(:account) }
    let(:user) { create(:employee, with_admin_role: true, account:) }

    it { should(permit_actions([:index, :new, :create])) }
    it { should(permit_actions([:edit, :update, :resend_invitation])) }
    it { should(permit_actions([:show, :update_status])) }
  end
end
