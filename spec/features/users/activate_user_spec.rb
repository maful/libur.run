# frozen_string_literal: true

require "rails_helper"

describe "Activate user" do
  let!(:company) { create(:company) }
  let(:account) { create(:account, :verified) }
  let!(:admin) { create(:employee, with_admin_role: true, account:) }

  before do
    login(account)
  end

  it "when user is archived" do
    employee = create(:employee, :archived, with_manager_assigned: false)

    visit users_path
    expect(page).to(have_content("Users"))
    find(:xpath, ".//table/tbody/tr[1]/td[1]/a").click

    expect(page).to(have_current_path(user_path(employee)))
    within :xpath, ".//main/div/div[1]/div/div[2]/div" do
      click_button "Action"
      expect(page).to(have_selector('div[data-dropdown-target="menu"].button-dropdown__menu.button-dropdown__menu--right-direction'))
      expect(page).to(have_selector("a", text: "Activate"))
      find("a", text: "Activate").click
    end

    expect(page).to(have_content("Users"))
    expect(page).to(have_current_path(users_path))
    expect(employee.reload.active?).to(be_truthy)
    within :xpath, ".//table/tbody/tr[1]/td[5]" do
      expect(find("a")).to(have_content("Active"))
    end
  end

  it "when user is already active" do
    arhived_employee = create(:employee, with_manager_assigned: false)

    visit users_path
    expect(page).to(have_content("Users"))
    find(:xpath, ".//table/tbody/tr[1]/td[1]/a").click

    expect(page).to(have_current_path(user_path(arhived_employee)))
    within :xpath, ".//main/div/div[1]/div/div[2]/div" do
      click_button "Action"
      expect(page).to(have_selector('div[data-dropdown-target="menu"].button-dropdown__menu.button-dropdown__menu--right-direction'))
      expect(page).not_to(have_selector("a", text: "Activate"))
    end

    expect(page).to(have_current_path(user_path(arhived_employee)))
    expect(arhived_employee.reload.active?).to(be_truthy)
  end
end