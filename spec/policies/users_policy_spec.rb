# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UsersPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a visitor" do
    let(:user) { build(:employee) }

    it { should(forbid_action(:index)) }
  end

  context "when being a user" do
    let(:user) { create(:employee) }

    it { should(forbid_action(:index)) }
  end

  context "when being an admin" do
    let(:user) { create(:admin) }

    it { should(permit_actions([:index, :new, :create])) }
    it { should(permit_actions([:edit, :update, :resend_invitation])) }
    it { should(permit_actions([:show, :update_status])) }
  end
end
