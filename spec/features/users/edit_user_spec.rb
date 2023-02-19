# frozen_string_literal: true

require "rails_helper"

describe "Updating a user" do
  let!(:company) { create(:company) }
  let(:account) { create(:account, :verified) }
  let!(:admin) { create(:employee, with_manager_assigned: false, with_admin_role: true, account:) }
  let!(:manager) { create(:employee, with_manager_assigned: false, with_manager_role: true) }
  let!(:employee) { create(:employee, with_manager_assigned: false, with_address: true) }

  before do
    login(account)
  end

  it "valid inputs" do
    visit users_path
    expect(page).to(have_content("Users"))

    within :xpath, ".//table/tbody/tr[1]" do
      click_link "Edit"
    end

    expect(page).to(have_content("Update User"))
    expect(page).to(have_current_path(edit_user_path(employee)))

    new_name = "Bian"
    new_id = "709-16-1636"
    within "form#form_employee_#{employee.id}" do
      fill_in "user[identity_number]", with: new_id
      fill_in "user[name]", with: new_name

      click_button "Update user", name: "commit"
    end

    expect(page).to(have_content("Users"))
    expect(page).to(have_content("User was successfully updated."))
    within(:xpath, ".//table/tbody/tr[1]") do
      expect(find(:xpath, ".//td[1]/a/div/h3")).to(have_content(new_name))
    end
  end

  it "invalid inputs" do
    visit users_path
    expect(page).to(have_content("Users"))

    within :xpath, ".//table/tbody/tr[1]" do
      click_link "Edit"
    end

    expect(page).to(have_content("Update User"))
    expect(page).to(have_current_path(edit_user_path(employee)))

    within "form#form_employee_#{employee.id}" do
      fill_in "user[identity_number]", with: ""
      fill_in "user[name]", with: ""

      click_button "Update user", name: "commit"
    end

    expect(page).to(have_content("Update User"))
    expect(page).to(have_current_path(edit_user_path(employee)))
    within "form#form_employee_#{employee.id}" do
      expect(page).to(have_content("Name can't be blank"))
    end
  end
end
