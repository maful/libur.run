# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Settings::MyProfilePolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a user" do
    let(:account) { create(:account, with_employee: true) }
    let(:user) { account.employee }

    it { should(permit_action(:show)) }
  end
end
