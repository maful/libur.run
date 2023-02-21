# frozen_string_literal: true

require "rails_helper"

describe "Leave summary" do
  let(:lt_annual_leave) { create(:leave_type, name: "Annual Leave") }
  let(:lt_sick_leave) { create(:leave_type, name: "Sick Leave") }
  let(:lt_family_leave) { create(:leave_type, name: "Family Leave") }
  let(:manager) { create(:manager) }
  let(:employee) { create(:employee, manager:) }
  let(:leave1) { create(:leave, leave_type: lt_sick_leave, manager:, employee:) }
  let(:leave2) { create(:leave, :half_day, leave_type: lt_annual_leave, manager:, employee:) }

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  before do
    lt_annual_leave
    lt_sick_leave
    lt_family_leave
    leave1.accepted!
    leave2.accepted!
    login(employee.account)
  end

  it "history" do
    visit leaves_path
    expect(page).to(have_content("My Leaves"))
    expect(page).to(have_current_path(leaves_path))

    click_link("Leave Summary", href: summary_leaves_path)
    expect(page).to(have_selector("h1", text: "Leave Summary"))
    expect(page).to(have_current_path(summary_leaves_path))
    # verify the total leave type group
    expect(page).to(have_xpath(".//main/div/div[2]/div", count: 3))

    # verify the group title
    expect(find(:xpath, ".//main/div/div[2]/div[1]/span")).to(have_content(lt_family_leave.name))
    # there is no history, so the total item is 2 which from the layout
    within(:xpath, ".//main/div/div[2]/div[1]") do
      expect(page).to(have_selector("div.list > div.list__item", count: 2))
    end

    # verify the group title
    expect(find(:xpath, ".//main/div/div[2]/div[2]/span")).to(have_content(lt_sick_leave.name))
    # verify total history item, including from the layout (2)
    within(:xpath, ".//main/div/div[2]/div[2]") do
      expect(page).to(have_selector("div.list > div.list__item", count: 3))
    end

    # verify the group title
    expect(find(:xpath, ".//main/div/div[2]/div[3]/span")).to(have_content(lt_annual_leave.name))
    # verify total history item, including from the layout (2)
    within(:xpath, ".//main/div/div[2]/div[3]") do
      expect(page).to(have_selector("div.list > div.list__item", count: 3))
    end
  end
end
