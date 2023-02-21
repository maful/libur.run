# frozen_string_literal: true

require "rails_helper"

describe "Cancel leave" do
  let(:leave_type) { create(:leave_type, name: "Annual Leave") }
  let(:employee) { create(:employee) }
  let(:leave) { create(:leave, :half_day, leave_type:, employee:, manager: employee.manager) }

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  before do
    leave
    login(employee.account)
  end

  it "status is pending" do
    visit leaves_path
    within(:xpath, ".//turbo-frame[@id='leaves-list']/table/tbody/tr[1]/td[1]") do
      find("a[data-turbo-frame='turbo_modal']").click
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Leave Details"))
      expect(find("div.modal__body > div.list-group")).to(have_selector("ul.list-group__item", count: 6))
      find("div.modal__footer").click_button("Cancel Leave Request")
    end
    expect(page).not_to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("dialog[open]#turbo-confirm") do
      expect(page).to(have_selector("h3#title", text: "Confirmation"))
      find("form[method='dialog']").click_button("Cancel Leave Request")
    end
    expect(page).not_to(have_selector("dialog[open]#turbo-confirm"))
    expect(page).to(have_content("Leave request has been successfully canceled"))
    expect(leave.reload).to(be_canceled)
  end

  it "status is not pending" do
    visit leaves_path
    within(:xpath, ".//turbo-frame[@id='leaves-list']/table/tbody/tr[1]/td[1]") do
      find("a[data-turbo-frame='turbo_modal']").click
    end

    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Leave Details"))
      expect(page).to(have_selector("div.modal__footer"))
    end
    expect(leave.reload).to(be_pending)
  end
end
