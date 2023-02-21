# frozen_string_literal: true

require "rails_helper"

describe "Creating a user" do
  let(:manager) { create(:employee, with_manager_assigned: false, with_manager_role: true) }

  before do
    login(DataVariables.admin.account)
    manager
  end

  it "valid inputs" do
    visit users_path
    expect(page).to(have_content("Users"))

    click_on("Invite user")
    expect(page).to(have_content("Invite your team member"))
    expect(page).to(have_current_path(new_user_path))

    name = Faker::Name.name
    email = Faker::Internet.unique.email(domain: "example")
    within "form#form_employee" do
      fill_in "user_about", with: "lorem ipsum dolor init"
      fill_in "user[identity_number]", with: Faker::IDNumber.valid
      fill_in "user[passport_number]", with: ""
      fill_in "user[name]", with: name
      fill_in "user[account_attributes][email]", with: email
      fill_in "user[phone_number]", with: Faker::PhoneNumber.cell_phone_in_e164
      fill_in "user[birthday]", with: Date.new(1999, 12, 31).to_s
      select "Islam", from: "user[religion]"
      select "Single", from: "user[marital_status]"
      select "Indonesia", from: "user[citizenship]"
      fill_in "user[address_attributes][line_1]", with: Faker::Address.street_address
      fill_in "user[address_attributes][line_2]", with: Faker::Address.secondary_address
      fill_in "user[address_attributes][city]", with: Faker::Address.city
      fill_in "user[address_attributes][state]", with: Faker::Address.state
      select "Indonesia", from: "user[address_attributes][country_code]"
      fill_in "user[address_attributes][zip]", with: Faker::Address.zip
      fill_in "user[position]", with: Faker::Job.title
      select "Indonesia", from: "user[country_of_work]"
      fill_in "user[start_date]", with: (Date.current - 1.year).to_s
      select "#{manager.name} (#{manager.account.email})", from: "user[manager_id]"
      check "user[assignments_attributes][0][role_id]"

      click_button "Invite user", name: "commit"
    end

    expect(page).to(have_content("Users"))
    expect(page).to(have_content("User was successfully created."))
    expect(page).to(have_current_path(users_path))
    within :xpath, ".//table/tbody/tr[1]/td[1]/a/div" do
      expect(find("h3")).to(have_content(name))
      expect(find("p")).to(have_content(email))
    end
  end

  it "invalid inputs" do
    visit new_user_path
    expect(page).to(have_content("Invite your team member"))
    expect(page).to(have_current_path(new_user_path))

    within "form#form_employee" do
      click_button "Invite user", name: "commit"
    end

    expect(page).to(have_current_path(new_user_path))
    within "form#form_employee" do
      expect(page).to(have_content("Identity number can't be blank"))
      expect(page).to(have_content("Name can't be blank"))
      expect(page).to(have_content("Email can't be blank"))
      expect(page).to(have_content("Birthday can't be blank"))
      expect(page).to(have_content("Religion can't be blank"))
      expect(page).to(have_content("Marital status can't be blank"))
      expect(page).to(have_content("Citizenship can't be blank"))
      expect(page).to(have_content("Line 1 can't be blank"))
      expect(page).to(have_content("City can't be blank"))
      expect(page).to(have_content("State can't be blank"))
      expect(page).to(have_content("Country code can't be blank"))
      expect(page).to(have_content("Zip can't be blank"))
      expect(page).to(have_content("Start date can't be blank"))
    end
  end
end
