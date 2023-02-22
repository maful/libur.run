# frozen_string_literal: true

require "rails_helper"

describe "Approve claim" do
  let(:manager) { create(:manager) }
  let(:employee) { create(:employee, manager:) }
  let(:ct_travel) { create(:claim_type, name: "Travel expenses") }
  let(:claim_group) do
    cg = build(:claim_group, employee:)
    cg.claims << build(:claim, employee:, claim_type: ct_travel)
    cg.save
    cg
  end

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  before do
    DataVariables.company.update(finance_approver: manager)
    login(manager.account)
    claim_group
  end

  it "valid comments" do
    visit team_claims_path

    within(:xpath, ".//turbo-frame[@id='team-claim-groups-list']/table/tbody/tr[1]/td[1]") do
      find("a[data-turbo-frame='turbo_modal']").click
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Claim Details"))
      expect(find("div.modal__body > div.list-group")).to(have_selector("ul.list-group__item", count: 5))
      expect(page).to(have_selector("table tbody tr", count: 1))
      find("div.modal__footer").click_button("Approve Claim Request")
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    url = URI.parse(find("turbo-frame#turbo_modal")["src"])
    expect("#{url.path}?#{url.query}").to(eq(edit_team_claim_path(claim_group, type: "approve")))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Claim Approval"))
      fill_in("claim_group[comment]", with: "Thank you!")
      click_button("Approve")
    end

    expect(page).to(have_content(I18n.t("dashboard.team_claims.form.approve.notification")))
    expect(find("table > tbody > tr:nth-child(1) > td:nth-child(3)")).to(have_content("Approved"))
    expect(claim_group.reload).to(be_approved)
  end

  it "invalid comments" do
    visit team_claims_path

    within(:xpath, ".//turbo-frame[@id='team-claim-groups-list']/table/tbody/tr[1]/td[1]") do
      find("a[data-turbo-frame='turbo_modal']").click
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      find("div.modal__footer").click_button("Approve Claim Request")
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    url = URI.parse(find("turbo-frame#turbo_modal")["src"])
    expect("#{url.path}?#{url.query}").to(eq(edit_team_claim_path(claim_group, type: "approve")))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Claim Approval"))
      fill_in("claim_group[comment]", with: Faker::Lorem.sentence(word_count: 20))
      click_button("Approve")
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: "Comment 100 characters is the maximum allowed",
      ))
    end
    expect(claim_group.reload).to(be_pending)
  end
end
