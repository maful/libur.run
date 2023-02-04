# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AddressDecorator) do
  let(:decorator) { AddressDecorator.new(object) }
  let(:object) { create(:address, country_code: "ID") }

  it "can get country name" do
    expect(decorator.country_name).to(eq("Indonesia"))
  end
end
