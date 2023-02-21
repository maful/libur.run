# frozen_string_literal: true

require "rails_helper"

describe "Reject leave request" do
  let!(:leave_type) { create(:leave_type, name: "Annual Leave") }
  let(:manager) { create(:manager) }
  let(:employee) { create(:employee, manager:) }
  let(:leave) { create(:leave, leave_type:, manager:, employee:) }
  let(:leave_approved) { create(:leave, :approved, leave_type:, manager:, employee:) }

  before do
    login(manager.account)
  end

  it "valid comment" do
    leave
    visit team_leaves_path

    within(:xpath, ".//turbo-frame[@id='team-leaves-list']/table/tbody/tr[1]/td[1]") do
      find("a[data-turbo-frame='turbo_modal']").click
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Leave Details"))
      expect(find("div.modal__body > div.list-group")).to(have_selector("ul.list-group__item", count: 7))
      find("div.modal__footer").click_button("Reject Leave Request")
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    url = URI.parse(find("turbo-frame#turbo_modal")["src"])
    expect("#{url.path}?#{url.query}").to(eq(edit_team_leave_path(leave, type: "reject")))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Leave Rejection"))
      fill_in("leave[comment]", with: "Leave request denied. We have an important project coming up.")
      click_button("Reject")
    end

    expect(page).to(have_content(I18n.t("dashboard.team_leaves.form.reject.notification")))
    expect(find("table > tbody > tr:nth-child(1) > td:nth-child(5)")).to(have_content("Denied"))
    expect(leave.reload).to(be_denied)
  end

  it "comment is too long" do
    leave
    visit team_leaves_path

    within(:xpath, ".//turbo-frame[@id='team-leaves-list']/table/tbody/tr[1]/td[1]") do
      find("a[data-turbo-frame='turbo_modal']").click
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Leave Details"))
      find("div.modal__footer").click_button("Reject Leave Request")
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    url = URI.parse(find("turbo-frame#turbo_modal")["src"])
    expect("#{url.path}?#{url.query}").to(eq(edit_team_leave_path(leave, type: "reject")))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Leave Rejection"))
      fill_in(
        "leave[comment]",
        with: "Sorry, but I won't be able to approve your leave request at this time. "\
          "Please let me know if there is anything we can do to make it possible in the future.",
      )
      click_button("Reject")
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: "Comment 100 characters is the maximum allowed",
      ))
    end
    expect(leave.reload).to(be_pending)
  end

  it "status is not pending" do
    leave_approved
    visit team_leaves_path

    within(:xpath, ".//turbo-frame[@id='team-leaves-list']/table/tbody/tr[1]/td[1]") do
      find("a[data-turbo-frame='turbo_modal']").click
    end

    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Leave Details"))
      expect(page).not_to(have_selector("div.modal__footer"))
    end
  end
end
