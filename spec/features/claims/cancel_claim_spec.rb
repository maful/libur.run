# frozen_string_literal: true

require "rails_helper"

describe "Cancel claim" do
  let(:employee) { create(:employee) }
  let(:claim_type) { create(:claim_type, name: "Travel expenses") }
  let(:claim_group) do
    cg = build(:claim_group, employee:)
    cg.claims << build(:claim, employee:, claim_type:)
    cg.save
    cg
  end

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  before do
    login(employee.account)
    claim_group
  end

  it "cancel" do
    visit claims_path

    within(:xpath, ".//turbo-frame[@id='claim-groups-list']/table/tbody/tr[1]/td[1]") do
      find("a[data-turbo-frame='turbo_modal']").click
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Claim Details"))
      expect(find("div.modal__body > div.list-group")).to(have_selector("ul.list-group__item", count: 5))
      expect(page).to(have_selector("table tbody tr", count: 1))
      find("div.modal__footer").click_button("Cancel Claim")
    end
    expect(page).not_to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("dialog[open]#turbo-confirm") do
      expect(page).to(have_selector("h3#title", text: "Confirmation"))
      find("form[method='dialog']").click_button("Cancel Claim")
    end
    expect(page).not_to(have_selector("dialog[open]#turbo-confirm"))
    expect(page).to(have_content("Claim request has been successfully canceled"))
    expect(claim_group.reload).to(be_canceled)
  end
end
