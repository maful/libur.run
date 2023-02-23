# frozen_string_literal: true

require "rails_helper"

RSpec.describe(CalendarPolicy, type: :policy) do
  subject { described_class.new(user, object) }

  let(:object) { nil }

  context "when being a visitor" do
    let(:user) { build(:employee) }

    it { should(forbid_action(:index)) }
  end

  context "when being a user" do
    let(:user) { create(:employee) }

    it { should(permit_action(:index)) }
  end
end
