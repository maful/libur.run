# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SecurityLog) do
  describe "associations" do
    it { should belong_to(:trackable) }
    it { should belong_to(:owner).optional }
    it { should belong_to(:recipient).optional }
  end
end
